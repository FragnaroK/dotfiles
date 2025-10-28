import sys
import argparse
import subprocess
from pathlib import Path
 
APP_NAME: str = 'Visual Studio Code'

def get_open_path() -> str:
    parser = argparse.ArgumentParser(description="Open VSCode from CLI")
    parser.add_argument('path', nargs='?', default=str(Path.cwd()))
    args = parser.parse_args()
 
    open_path = Path(args.path).expanduser().resolve()

    if not open_path.exists():
        print(f"Error: Path '{open_path}' does not exist.")
        sys.exit(1)

    return str(open_path)

def main() -> None:
    open_path = get_open_path()

    subprocess.call([
        'open',
        '-n',
        f'/Applications/{APP_NAME}.app',
        '--args',
        open_path
    ], cwd=open_path)

if __name__ == '__main__':
    main()