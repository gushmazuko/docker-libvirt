#!/usr/bin/env bash

if [[ ! -z ${SSH_PORT} ]]; then
  sed -i "s/.*Port.*/Port ${SSH_PORT}/g" /etc/ssh/sshd_config
fi

if [[ ${SSH_ROOT_PASSWORD_AUTH} == no ]]; then
  sed -i "s/.*PermitRootLogin.*/PermitRootLogin prohibit-password/g" /etc/ssh/sshd_config
elif [[ ${SSH_ROOT_PASSWORD_AUTH} == yes ]]; then
  sed -i "s/.*PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
fi

if [[ ${SSH_PASSWORD_AUTH} == no ]]; then
  sed -i "s/.*PasswordAuthentication.*/PasswordAuthentication no/g" /etc/ssh/sshd_config
elif [[ ${SSH_PASSWORD_AUTH} == yes ]]; then
  sed -i "s/.*PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config
fi

if [[ ! -z ${SSH_PUB_KEY} ]]; then
  mkdir ~/.ssh
  echo ${SSH_PUB_KEY} | tee ~/.ssh/authorized_keys
fi

exec "$@"
