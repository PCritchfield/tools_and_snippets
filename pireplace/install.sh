#! /bin/bash

# # Absolute path to this script, e.g. /home/user/bin/foo.sh
# SCRIPT=$(readlink -f "$0")
# # Absolute path this script is in, thus /home/user/bin
# SCRIPTPATH=$(dirname "$SCRIPT")
# PATIOBAR_DIR="$SCRIPTPATH/patiobar"
# UTILS_DIR=${SCRIPTPATH}/utils
# TLS_FINGERPRINT=`openssl s_client -connect tuner.pandora.com:443 < /dev/null 2> /dev/null | openssl x509 -noout -fingerprint | tr -d ':' | cut -d'=' -f2`
# EVENT_COMMAND=$PATIOBAR_DIR/eventcmd.sh
# FIFO=$PATIOBAR_DIR/ctl
# CONFIG_DIR=~/test

# # INPUT DEFAULTS
# USER_NAME=user@example.com
# PASSWORD=password
# AUTOSTART_STATION="#autostart_station = 12345"

. ./config

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -u|--username)
    USER_NAME="$2"
    shift # past argument
    shift # past value
    ;;
    -p|--password)
    PASSWORD="$2"
    shift # past argument
    shift # past value
    ;;
    -s|--autostart_station)
    AUTOSTART_STATION="autostart_station = $2"
    shift # past argument
    shift # past value
    ;;
    --default|-h|--help)
    DEFAULT=YES
    echo "-u --username --> Login username for Pandora Radio"
    echo "-p --password --> Login password for Pandora Radio"
    echo "-s --autostart_station --> The default station for Pandora to play on start"
    echo "-h --help --> Prints these options"
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

sudo apt update
sudo apt install -y \
 pianobar \
 npm \
 screen

git clone https://github.com/kylejohnson/Patiobar.git $PATIOBAR_DIR

# Don't run npm install if it has already ran
cd $PATIOBAR_DIR
if [ ! -d "node_modules" ]; then
        echo -n 'Running `npm install`...   '
        if npm install > /dev/null 2>&1; then
                echo "success"
        else
                echo "failure"
        fi
fi
cd $SCRIPTPATH

# Don't create fifo if it already exists
if [ ! -p "${FIFO}" ]; then
        echo -n "Creating ${FIFO} control file...   "
        if mkfifo "${FIFO}" > /dev/null 2>&1; then
                echo "success"
        else
                echo "failure"
        fi
fi

echo -n "Creating the Pianobar config at ${CONFIG_DIR}/config file...   "
if mkdir -p "${CONFIG_DIR}"; then
    if ! [ -f "${CONFIG_DIR}/config" ]; then
        if cat << EOF >> "${CONFIG_DIR}/config"; then
user = ${USER_NAME}
password = ${PASSWORD}
${AUTOSTART_STATION}
audio_quality = high
event_command = ${EVENT_COMMAND}
fifo = ${FIFO}
tls_fingerprint = ${TLS_FINGERPRINT}
EOF
            echo "success"
            echo "If no options were set remember to update the Pianobar config"
        else
            echo "failure"
        fi
    else
        echo "${CONFIG_DIR}/config already exists"
    fi
fi
