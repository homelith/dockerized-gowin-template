# template project for gowin-tools:1.9.8.07

## quick start

- get `docker` command introduced and accesible from non-privilege user
- `$ make docker` and get gowin 1.9.8.07 suitable ubuntu console
- `$ /root/install.sh` to install tools on /opt/Gowin
- now you can use `gw_ide`, `openFPGALoader` and some gowin tools

## manage gowin license

- prepare `gowin_E_{MAC address}.lic` and place directory accesible from docker environment (e.g. /opt/Gowin/license)
- you should specify license file path on first boot on `gw_ide`
