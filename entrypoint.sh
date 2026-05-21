#!/bin/bash
set -e

ROOT_PASSWORD="${ROOT_PASSWORD:-changeme}"
echo "root:${ROOT_PASSWORD}" | chpasswd

if [ -n "${SSH_PUBLIC_KEY}" ]; then
    mkdir -p /root/.ssh
    echo "${SSH_PUBLIC_KEY}" > /root/.ssh/authorized_keys
    chmod 700 /root/.ssh
    chmod 600 /root/.ssh/authorized_keys
fi

exec /usr/sbin/sshd -D
