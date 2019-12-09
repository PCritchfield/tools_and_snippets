#! /bin/bash

# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")
PATIOBAR_DIR=~/Patiobar
UTILS_DIR=${SCRIPTPATH}/utils
TLS_FINGERPRINT=`openssl s_client -connect tuner.pandora.com:443 < /dev/null 2> /dev/null | openssl x509 -noout -fingerprint | tr -d ':' | cut -d'=' -f2`
EVENT_COMMAND=$PATIOBAR_DIR/eventcmd.sh
FIFO=$PATIOBAR_DIR/ctl
CONFIG_DIR=~/test

# INPUT DEFAULTS
USER_NAME=user@example.com
PASSWORD=password
AUTOSTART_STATION="#autostart_station = 12345"


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
    --default)
    DEFAULT=YES
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

# sudo apt update
# sudo apt install -y \
#  pianobar \
#  npm \
#  screen

# git clone https://github.com/kylejohnson/Patiobar.git $PATIOBAR_DIR

# # Don't run npm install if it has already ran
# if [ ! -d node_modules ]; then
#         echo -n 'Running `npm install`...   '
#         if npm install > /dev/null 2>&1; then
#                 echo "success"
#         else
#                 echo "failure"
#         fi
# fi

# # Don't create fifo if it already exists
# if [ ! -p "${FIFO}" ]; then
#         echo -n "Creating ${FIFO} control file...   "
#         if mkfifo "${FIFO}" > /dev/null 2>&1; then
#                 echo "success"
#         else
#                 echo "failure"
#         fi
# fi

# echo -n "Creating the Pianobar config at ${CONFIG_DIR}/config file...   "
# if mkdir -p "${CONFIG_DIR}"; then
#     if ! [ -f "${CONFIG_DIR}/config" ]; then
#         if cat << EOF >> "${CONFIG_DIR}/config"; then
# user = ${USER_NAME}
# password = ${PASSWORD}
# ${AUTOSTART_STATION}
# audio_quality = high
# event_command = ${EVENT_COMMAND}
# fifo = ${FIFO}
# tls_fingerprint = ${TLS_FINGERPRINT}
# EOF
#             echo "success"
#             echo "If no options were set remember to update the Pianobar config"
#         else
#             echo "failure"
#         fi
#     else
#         echo "${CONFIG_DIR}/config already exists"
#     fi
# fi

echo -n "Creating the Pianobar start and stop scripts at ${UTILS_DIR} ...   "
if mkdir -p "${UTILS_DIR}"; then
## pbstart
    if ! [ -f "${UTILS_DIR}/pbstart" ]; then
        if cat << EOF >> "${UTILS_DIR}/pbstart"; then
#!/bin/bash
cd ${PATIOBAR_DIR}
# Kill any old Patiobar processes running
pbstop 1> /dev/null
screen -S pianobar -d -m bash -c 'pianobar'
# The "patiobar" in the end is not needed and is used as an identifier so we can kill it when stopping.
# Otherwise, we might kill other "node index.js" processes.
node index.js patiobar > /dev/null 2>&1 &
echo "Go to http://$(hostname):3000/ to launch the Web interface."
EOF
            chmod u+x ${UTILS_DIR}/pbstart
            echo "success"
        else
            echo "failure"
        fi
    else
        echo "${UTILS_DIR}/pbstart already exists"
    fi
## pbstop
    if ! [ -f "${UTILS_DIR}/pbstop" ]; then
        if cat << EOF >> "${UTILS_DIR}/pbstop"; then
#!/bin/bash
echo Closing out Pandora processes...
pkill -xf "SCREEN -S pianobar -d -m bash -c pianobar"
pkill -xf "node index.js patiobar"
echo done
EOF
            chmod u+x ${UTILS_DIR}/pbstop
            echo "success"
        else
            echo "failure"
        fi
    else
        echo "${UTILS_DIR}/pbstop already exists"
    fi
fi