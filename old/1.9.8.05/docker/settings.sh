#!/bin/bash
GOWIN_TOOL_VERSION=1.9.8.05
GOWIN_ROOT_DIR=/opt/Gowin

export QT_X11_NO_MITSHM=1
if [ -z ${LD_LIBRARY_PATH} ]; then
	export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:${GOWIN_ROOT_DIR}/${GOWIN_TOOL_VERSION}/IDE/lib
else
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/lib/x86_64-linux-gnu:${GOWIN_ROOT_DIR}/${GOWIN_TOOL_VERSION}/IDE/lib
fi
export PATH=${PATH}:${GOWIN_ROOT_DIR}/${GOWIN_TOOL_VERSION}/IDE/bin
export PATH=${PATH}:${GOWIN_ROOT_DIR}/${GOWIN_TOOL_VERSION}/Programmer/bin
echo "---- gowin-tools:${GOWIN_TOOL_VERSION} container shell ----"
if !(type gw_ide > /dev/null 2>&1); then
	echo "command 'gw_ide' not found. try '$ /root/install.sh' to install tools on /opt"
else
	echo "'gw_ide', 'programmer_cli' and some gowin tools successfully introduced on your PATH"
fi
xhost +
