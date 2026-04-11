#!/usr/bin/env bash

# Copyright (c) 2021-2026 community-scripts ORG
# Author: dapo01
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://github.com/openclaw/openclaw

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get update
$STD apt-get install -y \
  curl \
  git \
  gh \
  ripgrep \
  ffmpeg \
  gnupg \
  ca-certificates
msg_ok "Installed Dependencies"

msg_info "Installing Node.js 24"
curl -fsSL https://deb.nodesource.com/setup_24.x | bash - &>/dev/null
$STD apt-get install -y nodejs
msg_ok "Installed Node.js $(node -v)"

msg_info "Installing OpenClaw"
$STD npm install -g openclaw@latest
msg_ok "Installed OpenClaw $(openclaw --version 2>/dev/null || echo '')"

msg_info "Creating Data Directory"
mkdir -p /root/.openclaw
msg_ok "Created /root/.openclaw"

msg_info "Creating Systemd Service"
cat <<'EOF' >/etc/systemd/system/openclaw.service
[Unit]
Description=OpenClaw Gateway
After=network.target

[Service]
ExecStart=/usr/bin/openclaw gateway --port 18789
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable --now openclaw &>/dev/null
msg_ok "Created Systemd Service"

motd_ssh
customize
