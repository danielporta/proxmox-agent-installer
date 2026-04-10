#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/danielporta/proxmox-agent-installer/main/misc/build.func)
# Copyright (c) 2021-2026 community-scripts ORG
# Author: dapo01
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://github.com/openclaw/openclaw

APP="OpenClaw"
var_tags="${var_tags:-ai;agent;messaging}"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-2048}"
var_disk="${var_disk:-8}"
var_os="${var_os:-debian}"
var_version="${var_version:-13}"
var_unprivileged="${var_unprivileged:-1}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources

  if [[ ! -f /usr/bin/openclaw ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi

  msg_info "Stopping Service"
  systemctl stop openclaw
  msg_ok "Stopped Service"

  msg_info "Updating OpenClaw"
  npm install -g openclaw@latest &>/dev/null
  msg_ok "Updated OpenClaw"

  msg_info "Starting Service"
  systemctl start openclaw
  msg_ok "Started Service"
  msg_ok "Updated successfully!"
  exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Complete setup by running:${CL}"
echo -e "${TAB}${BGN}openclaw onboard${CL}"
echo -e "${INFO}${YW} Then start the service:${CL}"
echo -e "${TAB}${BGN}systemctl start openclaw${CL}"
echo -e "${INFO}${YW} Access the Gateway at:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:18789${CL}"
echo -e "${INFO}${YW} Configuration directory:${CL}"
echo -e "${TAB}${BGN}~/.openclaw/${CL}"
