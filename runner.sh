#!/bin/bash

echo "=== WireGuard/SSH GitHub Action ==="

SSH_USER=${SSH_USER:-root}
SSH_PORT=${SSH_PORT:-root}
SSH_HOST=${SSH_HOST:-root}
SSH_KEY=${SSH_KEY:-root}
SSH_SCRIPT=${SSH_SCRIPT:-root}
WIREGUARD_CONFIG=${WIREGUARD_CONFIG:-root}

echo "Installing WireGuard and SSH..."
# Install wireguard
apt-get update
apt-get install -y wireguard openssh-client

echo "Configuring WireGuard..."
# Create wireguard config
echo "$WIREGUARD_CONFIG" > /etc/wireguard/wg0.conf

echo "Starting WireGuard..."
# Start wireguard
wg-quick up wg0

echo "Running SSH script..."
ssh -o StrictHostKeyChecking=no -i "$SSH_KEY" -p "$SSH_PORT" "$SSH_USER"@"$SSH_HOST" "$SSH_SCRIPT"