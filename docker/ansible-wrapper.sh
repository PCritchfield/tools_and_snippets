#!/usr/bin/env bash

if [ -z "$SSH_AGENT_PID" ]; then
  eval $(ssh-agent)
  echo ********************
  env
  echo ********************
# ssh-add /root/.ssh/vhtx-build
  for possiblekey in ${HOME}/.ssh/*; do
    if grep -q PRIVATE "$possiblekey"; then
      ssh-add "$possiblekey"
      #echo "$possiblekey"
    fi
  done
fi

echo EXECUTING ansible-playbook "$@"
exec ansible-playbook "$@"