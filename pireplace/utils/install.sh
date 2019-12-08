#! /bin/bash

for arg in "$@"
do
    if [ "$arg" == "--username" ] || [ "$arg" == "-u" ]
    then
        USERNAME=$arg
    else
        echo "Update ~/.config/pianobar with the Pandora username"
        USERNAME=user@example.com
    fi
done

for arg in "$@"
do
    if [ "$arg" == "--password" ] || [ "$arg" == "-p" ]
    then
        PASSWORD=$arg
    else
        echo "Update ~/.config/pianobar with the Pandora password"
        PASSWORD=password
    fi
done

for arg in "$@"
do
    if [ "$arg" == "--autostart_station" ] || [ "$arg" == "-s" ]
    then
        AUTOSTART_STATION="autostart_station = ${arg}"
    else
        echo "Update ~/.config/pianobar with an autostart_station"
        AUTOSTART_STATION="#autostart_station = 12345"
    fi
done

# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")
PATIOBAR_DIR=$SCRIPTPATH/Patiobar
TLS_FINGERPRINT=`openssl s_client -connect tuner.pandora.com:443 < /dev/null 2> /dev/null | openssl x509 -noout -fingerprint | tr -d ':' | cut -d'=' -f2`
EVENT_COMMAND=$PATIOBAR_DIR/eventcmd.sh
FIFO=$PATIOBAR_DIR/ctl
CONFIG_DIR=~/.config/pianobar

sudo apt update
sudo apt install -y \
 pianobar \
 npm \
 screen

git clone https://github.com/kylejohnson/Patiobar.git $PATIOBAR_DIR

# Don't run npm install if it has already ran
if [ ! -d node_modules ]; then
        echo -n 'Running `npm install`...   '
        if npm install > /dev/null 2>&1; then
                echo "success"
        else
                echo "failure"
        fi
fi

# Don't create fifo if it already exists
if [ ! -p "${FIFO}" ]; then
        echo -n "Creating ${FIFO} control file...   "
        if mkfifo "${FIFO}" > /dev/null 2>&1; then
                echo "success"
        else
                echo "failure"
        fi
fi

echo -n "Creating default ~/.config/pianobar/config file...   "
if mkdir -p "${CONFIG_DIR}"; then
    if ! [ -f "${CONFIG_DIR}/config" ]; then
        if cat << EOF >> "${CONFIG_DIR}/config"; then
user = ${USERNAME}
password = ${PASSWORD}
${AUTOSTART_STATION}
audio_quality = high
event_command = ${EVENT_COMMAND}
fifo = ${FIFO}
tls_fingerprint = ${TLS_FINGERPRINT}
EOF
            echo "success"
        else
            echo "failure"
        fi
    else
        echo "${CONFIG_DIR}/config already exists"
    fi
fi