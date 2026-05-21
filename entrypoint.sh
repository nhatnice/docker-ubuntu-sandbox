#!/bin/bash
set -e

ROOT_PASSWORD="${ROOT_PASSWORD:-changeme}"
echo "root:${ROOT_PASSWORD}" | chpasswd

exec /usr/sbin/sshd -D
