#!/bin/bash

set -e
echo "=== WireGuard/SSH GitHub Action ==="

SSH_USER=${SSH_USER:-root}
SSH_PORT=${SSH_PORT:-22}
SSH_HOST=${SSH_HOST:?"Missing SSH_HOST argument"}
SSH_KEY=${SSH_KEY:?"Missing SSH_KEY argument"}
SSH_SCRIPT=${SSH_SCRIPT:?"Missing SSH_SCRIPT argument"}
WIREGUARD_CONFIG=${WIREGUARD_CONFIG:?"Missing WIREGUARD_CONFIG argument"}

echo "Installing WireGuard and SSH..."
# Install wireguard
sudo apt-get update -y
sudo apt-get install -y wireguard wireguard-tools openssh-client resolvconf

echo "Configuring WireGuard..."
# Create wireguard config
echo "$WIREGUARD_CONFIG" > ./wg0.conf
echo "$SSH_KEY" > ./ssh.pub

echo "Starting WireGuard..."
# Start wireguard
sudo wg-quick up ./wg0.conf

echo "Running SSH script..."
ssh -o ConnectTimeout=30 -o BatchMode=yes -o StrictHostKeyChecking=accept-new -i ./ssh.pub -p "$SSH_PORT" "$SSH_USER"@"$SSH_HOST" "$SSH_SCRIPT"