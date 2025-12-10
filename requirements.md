# Hyprland Config Requirements
## TODOs

- Review setup scripts approach

## Optional


### SDDM Theme: 

Repo reference: [SilentSDDM](https://github.com/uiriansan/SilentSDDM?tab=readme-ov-file)

1. *Clone the repo:* Run de following under `/home/<user>/.config/hypr/external`

```bash
git clone -b main --depth=1 https://github.com/uiriansan/SilentSDDM
cd SilentSDDM/
```

2. Test: Rune the following command in `SilentSDDM`:

```bash
./test.sh
```

3. If everything went fine, run the setup script:

```bash
/home/<user>/.config/hypr/scripts/setup-scripts/setup-sddm.sh
```

4. Set env variables in `/etc/sddm.conf`:

```bash
# Run
sudoedit /etc/sddm.conf

# Make sure these options are correct:
[General]
InputMethod=qtvirtualkeyboard
GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard

[Theme]
Current=silent
```

5. For customisation, please refer to the repo referenced at the beginning of this section.

