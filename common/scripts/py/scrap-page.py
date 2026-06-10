#!/usr/bin/env python3

from __future__ import annotations

import argparse
import hashlib
import mimetypes
import re
import sys
from pathlib import Path
from typing import Dict, Optional, Set, Any
from urllib.parse import urljoin, urlparse, unquote

import requests
from bs4 import BeautifulSoup
from bs4.element import NavigableString   


SKIP_SCHEMES = ("data:", "javascript:", "mailto:", "tel:", "blob:")
DEFAULT_HEADERS = {
    "User-Agent": "Mozilla/5.0"
}



def attr_to_str(value: Any) -> str:
    if value is None:
        return ""
    if isinstance(value, list):
        return " ".join(str(v) for v in value)
    return str(value)


class PageArchiver:
    def __init__(self, output_dir: Path, timeout: int = 30) -> None:
        self.output_dir = output_dir
        self.assets_dir = output_dir / "assets"
        self.timeout = timeout

        self.session = requests.Session()
        self.session.headers.update(DEFAULT_HEADERS)

        self.output_dir.mkdir(parents=True, exist_ok=True)
        self.assets_dir.mkdir(parents=True, exist_ok=True)

        self.asset_cache: Dict[str, str] = {}
        self.css_cache: Dict[str, str] = {}
        self.css_in_progress: Set[str] = set()

    @staticmethod
    def should_skip_url(value: str) -> bool:
        v = value.strip()
        return not v or v.startswith("#") or v.lower().startswith(SKIP_SCHEMES)

    @staticmethod
    def strip_quotes(value: str) -> str:
        value = value.strip()
        if len(value) >= 2 and value[0] == value[-1] and value[0] in {"'", '"'}:
            return value[1:-1]
        return value

    @staticmethod
    def safe_filename_from_url(url: str) -> str:
        path = unquote(urlparse(url).path)
        name = Path(path).name or "file"
        return re.sub(r"[^\w.\-]+", "_", name)

    def guess_extension(self, url: str, content_type: Optional[str]) -> str:
        suffix = Path(urlparse(url).path).suffix
        if suffix:
            return suffix

        if content_type:
            return mimetypes.guess_extension(content_type.split(";")[0]) or ""

        return ""

    def fetch_text(self, url: str, referer: Optional[str] = None) -> str:
        response = self.session.get(url, timeout=self.timeout,
                                    headers={"Referer": referer} if referer else {})
        response.raise_for_status()
        return response.text

    def fetch_binary(self, url: str, referer: Optional[str] = None) -> requests.Response:
        response = self.session.get(url, timeout=self.timeout,
                                    headers={"Referer": referer} if referer else {},
                                    stream=True)
        response.raise_for_status()
        return response

    def unique_asset_name(self, url: str, content_type: Optional[str]) -> str:
        base = Path(self.safe_filename_from_url(url)).stem
        ext = self.guess_extension(url, content_type)
        digest = hashlib.sha1(url.encode()).hexdigest()[:10]
        return f"{base}_{digest}{ext}"

    def download_asset(self, url: str, referer: Optional[str] = None) -> str:
        if url in self.asset_cache:
            return self.asset_cache[url]

        response = self.fetch_binary(url, referer)
        content_type = response.headers.get("Content-Type")

        filename = self.unique_asset_name(url, content_type)
        path = self.assets_dir / filename

        with path.open("wb") as f:
            for chunk in response.iter_content(65536):
                f.write(chunk)

        rel = f"assets/{filename}"
        self.asset_cache[url] = rel
        return rel

    def rewrite_srcset(self, value: str, base_url: str) -> str:
        parts = value.split(",")
        new_parts = []

        for part in parts:
            tokens = part.strip().split()
            if not tokens:
                continue

            raw_url = tokens[0]
            descriptor = " ".join(tokens[1:])

            if self.should_skip_url(raw_url):
                new_parts.append(part)
                continue

            full = urljoin(base_url, raw_url)
            local = self.download_asset(full, base_url)
            new_parts.append(f"{local} {descriptor}".strip())

        return ", ".join(new_parts)

    def process_css(self, css: str, base_url: str) -> str:
        url_pattern = re.compile(r'url\(([^)]+)\)', re.IGNORECASE)

        def repl(match: re.Match) -> str:
            raw = self.strip_quotes(match.group(1))
            if self.should_skip_url(raw):
                return match.group(0)

            full = urljoin(base_url, raw)
            try:
                local = self.download_asset(full, base_url)
                return f'url("{local}")'
            except Exception:
                return match.group(0)

        return url_pattern.sub(repl, css)

    def inline_stylesheets(self, soup: BeautifulSoup, base_url: str) -> None:
        for link in soup.find_all("link", href=True):
            rel_list = link.get("rel") or []
            rel_values = [str(v).lower() for v in rel_list]

            if "stylesheet" not in rel_values:
                continue

            href = attr_to_str(link.get("href")).strip()
            if self.should_skip_url(href):
                continue

            full = urljoin(base_url, href)

            try:
                css = self.fetch_text(full, base_url)
                css = self.process_css(css, full)

                style = soup.new_tag("style")
                style.append(NavigableString(css))
                link.replace_with(style)

            except Exception as e:
                print(f"[WARN] CSS failed: {full} {e}")

    def inline_scripts(self, soup: BeautifulSoup, base_url: str) -> None:
        for script in soup.find_all("script", src=True):
            src = attr_to_str(script.get("src")).strip()
            if self.should_skip_url(src):
                continue

            full = urljoin(base_url, src)

            try:
                js = self.fetch_text(full, base_url)

                new_tag = soup.new_tag("script")
                new_tag.append(NavigableString(js))
                script.replace_with(new_tag)

            except Exception as e:
                print(f"[WARN] JS failed: {full} {e}")

    def rewrite_assets(self, soup: BeautifulSoup, base_url: str) -> None:
        ATTRS = ["src", "href", "poster", "data"]

        for tag in soup.find_all(True):
            for attr in ATTRS:
                if not tag.has_attr(attr):
                    continue

                value = attr_to_str(tag.get(attr)).strip()

                if self.should_skip_url(value):
                    continue

                full = urljoin(base_url, value)

                try:
                    local = self.download_asset(full, base_url)
                    tag[attr] = local
                except Exception:
                    pass

            if tag.has_attr("srcset"):
                srcset = attr_to_str(tag.get("srcset"))
                tag["srcset"] = self.rewrite_srcset(srcset, base_url)

            if tag.has_attr("style"):
                style_val = attr_to_str(tag.get("style"))
                tag["style"] = self.process_css(style_val, base_url)

    def archive(self, url: str) -> Path:
        html = self.fetch_text(url)

        soup = BeautifulSoup(html, "html.parser")

        base = url

        base_tag = soup.find("base", href=True)

        if base_tag is not None:
            href_value = attr_to_str(base_tag.get("href")).strip()
            if href_value:
                base = urljoin(url, href_value)


        self.inline_stylesheets(soup, base)
        self.inline_scripts(soup, base)
        self.rewrite_assets(soup, base)

        output = self.output_dir / "index.html"
        output.write_text(str(soup), encoding="utf-8")

        return output


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("url")
    parser.add_argument("-o", "--output", default="page_archive")

    args = parser.parse_args()

    archiver = PageArchiver(Path(args.output))
    result = archiver.archive(args.url)

    print(f"Saved: {result}")


if __name__ == "__main__":
    main()