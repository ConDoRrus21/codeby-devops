#!/bin/bash
set -e

USER=vagrant
PUBKEY="/vagrant/keys/id_ed25519_vagrant.pub"
SSH_DIR="/home/${USER}/.ssh"


if [ -f "${PUBKEY}" ]; then
  mkdir -p "${SSH_DIR}"
  touch "${SSH_DIR}/authorized_keys"
  grep -qxF "$(cat ${PUBKEY})" "${SSH_DIR}/authorized_keys" || cat "${PUBKEY}" >> "${SSH_DIR}/authorized_keys"
  chmod 700 "${SSH_DIR}"
  chmod 600 "${SSH_DIR}/authorized_keys"
  chown -R ${USER}:${USER} "${SSH_DIR}"
fi


if ! dpkg -s openssh-server >/dev/null 2>&1; then
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server
fi
