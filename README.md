# dockerized-gowin-template

- template gowin project aims supporting multiple tool version and devboard
- docker recipes for installing and running gowin tools included, helps them run on various un-supported linux distros

## usage

- get docker command introduced and accessible from non-privilege user.
- select Gowin tool version on your purpose and `cd {TOOL_VERSION}`.
- `$ make docker` to build `gowin-tools:{TOOL_VERSION}` image and and get console on the container with project directory and /opt directory are mounted transparently.
- execute `$ /root/install.sh` to download and install gowin tools on /opt/Gowin/{TOOL\_VERSION}.
- now you can use `gw_ide` command to launch gowin ide and develop codes on your will. drill into some template projects for your board and test compiling.

## USB programmer redirection on container

- Sipeed Tang- series board usually have on-board USB-JTAG programmer but they are initially be treated as generic USB-Serial bridge with module `ftdi_sio`.

- set up udev rules to unbind them after plugged in
```
$ sudo cp tools/udev/50-tang-nano.rules /etc/udev/rules.d/
$ sudo mkdir -p /opt/bin
$ sudo cp tools/udev/usb_unbind.sh /opt/bin
$ sudo udevadm control --reload
$ sudo udevadm trigger
```

- `$ make docker` command args helps USB-JTAG programmer device accessible from inside the container, try gowin programmer scan to check they can grab devices or not.

## for Ubuntu 20.04 on Windows 10 WSL2

- get Gowin IDE GUI via VcXsrv
  + install VcXsrv and start with "disable access control" option
  + add `export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0` to your .bashrc

- usb redirection via usbipd
  + currently usbip support is enabled by default kernel on WSL2 of Windows 10 21H2

```
sudo apt install linux-tools-5.4.0-77-generic hwdata
sudo update-alternatives --install /usr/local/bin/usbip usbip /usr/lib/linux-tools/5.4.0-77-generic/usbip 20
```

## manage gowin product license

- for Education edition, you need no additinal license required. Be sure Edu version supports limited evaluation devices (e.g. sipeed tang-nano series).

- for Standard edition, you have to register gowin and request your own license file with your development machine's NIC MAC address.
  + you may get `gowin_{MAC address}.lic` `gowin_E_{MAC address}.lic` and `E-` version is suitable for 1.9.8.01 and later. license files could be stored /opt/Gowin/license to be accessible inside the docker environment.
  + first time you launched Gowin IDE, they requires license setup and you should specify license file path.
  + for WSL2 environment, it is difficult to determine fixed NIC MAC address. You can use `$ tools/add_dummy_if.sh {MAC address seperated by ':'}` to setup dummy I/F with specified MAC address.

## compilation helpers

- `{TOOL_VERSION}/{TARGET_BOARD}/Makefile` include useful helper commands to be used in docker environment.
- `$ make ide` : boot Gowin IDE with ${HOME} set to current directory
- `$ make program` : issue one time SRAM programming with openFPGALoader
- `$ make flash` : program to non-volatile memory with openFPGALoader
- `$ make clean` : cleanup generated files

## Licenses

- Copyrights of some wizard-generated files are held by Gowin Semiconductor Corporation, see header of indivisual files.
- Newly written codes are licensed under MIT license.
