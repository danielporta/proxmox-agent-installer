#!/usr/bin/env bash

# Copyright (c) 2021-2026 community-scripts ORG
# Author: dapo01
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://github.com/nousresearch/hermes-agent

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing System Dependencies"
$STD apt-get install -y \
  curl \
  git \
  gcc \
  python3-dev \
  libffi-dev \
  ripgrep \
  ffmpeg \
  ca-certificates
msg_ok "Installed System Dependencies"

msg_info "Installing Node.js 22"
curl -fsSL https://deb.nodesource.com/setup_22.x | bash - &>/dev/null
$STD apt-get install -y nodejs
msg_ok "Installed Node.js $(node -v)"

msg_info "Installing uv (Python Package Manager)"
curl -fsSL https://astral.sh/uv/install.sh | bash &>/dev/null
export PATH="$HOME/.local/bin:$PATH"
msg_ok "Installed uv $(uv --version)"

msg_info "Installing Python 3.11 via uv"
$STD uv python install 3.11
msg_ok "Installed Python 3.11"

msg_info "Cloning Hermes Agent"
mkdir -p /opt/hermes
$STD git clone https://github.com/NousResearch/hermes-agent.git /opt/hermes/hermes-agent
msg_ok "Cloned Hermes Agent"

msg_info "Creating Python Virtual Environment"
$STD uv venv /opt/hermes/venv --python 3.11
msg_ok "Created Virtual Environment"

msg_info "Installing Hermes Agent (Python Package)"
cd /opt/hermes/hermes-agent
$STD uv pip install --python /opt/hermes/venv/bin/python -e ".[all]"
msg_ok "Installed Hermes Agent"

msg_info "Creating Data Directories"
mkdir -p /root/.hermes/{sessions,logs,cron,hooks,skills,memories,image_cache,audio_cache,pairing,whatsapp/session}
msg_ok "Created /root/.hermes/"

msg_info "Installing CLI Symlink"
ln -sf /opt/hermes/venv/bin/hermes /usr/local/bin/hermes
msg_ok "Installed CLI: /usr/local/bin/hermes"

msg_info "Creating Systemd Service"
cat <<'EOF' >/etc/systemd/system/hermes.service
[Unit]
Description=Hermes Agent Gateway
Documentation=https://github.com/nousresearch/hermes-agent
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root
Environment="PATH=/opt/hermes/venv/bin:/usr/local/bin:/usr/bin:/bin"
ExecStart=/opt/hermes/venv/bin/hermes gateway
Restart=on-failure
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF
systemctl enable hermes &>/dev/null
msg_ok "Created Systemd Service"

motd_ssh
customize
