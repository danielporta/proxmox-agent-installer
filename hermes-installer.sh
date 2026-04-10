#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/danielporta/proxmox-agent-installer/main/misc/build.func)
# Copyright (c) 2021-2026 community-scripts ORG
# Author: dapo01
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://github.com/nousresearch/hermes-agent

APP="Hermes"
var_tags="${var_tags:-ai;agent;llm}"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-4096}"
var_disk="${var_disk:-12}"
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

  if [[ ! -f /usr/local/bin/hermes ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi

  msg_info "Stopping Service"
  systemctl stop hermes
  msg_ok "Stopped Service"

  msg_info "Updating Hermes Agent"
  cd /opt/hermes/hermes-agent
  git pull &>/dev/null
  /opt/hermes/venv/bin/uv pip install -e ".[all]" &>/dev/null
  msg_ok "Updated Hermes Agent"

  msg_info "Starting Service"
  systemctl start hermes
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
echo -e "${TAB}${BGN}hermes model${CL}"
echo -e "${INFO}${YW} Or run the full setup wizard:${CL}"
echo -e "${TAB}${BGN}hermes setup${CL}"
echo -e "${INFO}${YW} Then start the gateway service:${CL}"
echo -e "${TAB}${BGN}systemctl start hermes${CL}"
echo -e "${INFO}${YW} Configuration and data directory:${CL}"
echo -e "${TAB}${BGN}~/.hermes/${CL}"
