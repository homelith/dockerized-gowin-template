# dockerized-gowin-template

- template gowin project (aims) supporting multiple tool version and devboard
- docker recipes for installing and running gowin tools included, helps them run on various un-supported linux distros

## usage

- get docker command introduced and accessible from non-privilege user.

- select Gowin tool version on your purpose and `cd {TOOL_VERSION}`.
  + 1.9.8 : suitable for floating license server provided by sipeed, evaluating their Tang- series devboards.
  + 1.9.8.03\_Education : latest Education edition, requires no license but supports limited devices
  + 1.9.8.05 : latest version at May 6 2022.

- `$ make docker` to build `gowin-tools:{TOOL_VERSION}` image and and get console on the container with project directory and /opt directory are mounted transparently.

- execute `$ /root/install.sh` to download and install gowin tools on /opt/Gowin/{TOOL\_VERSION}.

- now you can use `gw_ide` command to launch gowin ide and develop codes on your will. drill into some template projects for your board and test compiling.

## USB programmer redirection on container

- Sipeed Tang- series board usually have on-board USB-JTAG programmer but they are initially be treated as generic USB-Serial bridge with module `ftdi_sio`.
- you may unbind them from `ftdi_sio` by using `sudo -c "echo -n {USB bus number upper half}:{USB bus number lower half} > /sys/bus/usb/drivers/ftdi_sio/unbind"`.
- `$ make docker` command args helps USB-JTAG programmer device accesible from inside the container, try gowin programmer scan to check they can grab devices or not.

## Licenses

- Copyrights of some wizard-generated files are held by Gowin Semiconductor Corporation, see header of indivisual files.
- Newly written codes are licensed under MIT license.
