#!/bin/bash
set -e

ROOT_PASSWORD="${ROOT_PASSWORD:-changeme}"
echo "root:${ROOT_PASSWORD}" | chpasswd

# Persist SSH host keys so the server fingerprint stays stable across restarts.
# /etc/ssh is NOT a volume (mounting a volume there would wipe sshd_config).
# Instead, host keys are stored in /var/lib/ssh-host-keys and copied in/out.
HOST_KEYS_DIR="/var/lib/ssh-host-keys"
if [ -z "$(ls -A "${HOST_KEYS_DIR}" 2>/dev/null)" ]; then
    ssh-keygen -A
    cp /etc/ssh/ssh_host_* "${HOST_KEYS_DIR}/"
else
    cp "${HOST_KEYS_DIR}"/ssh_host_* /etc/ssh/
fi

if [ -n "${SSH_PUBLIC_KEY}" ]; then
    mkdir -p /root/.ssh
    echo "${SSH_PUBLIC_KEY}" > /root/.ssh/authorized_keys
    chmod 700 /root/.ssh
    chmod 600 /root/.ssh/authorized_keys
fi

/usr/sbin/sshd
exec mcp-server-everything sse
