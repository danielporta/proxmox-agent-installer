# Proxmox Agent Installer

Proxmox LXC installers for AI agent frameworks, based on the [community-scripts](https://github.com/community-scripts/ProxmoxVE) pattern.

## Available Installers

| App | Description | RAM | Disk | Port |
|---|---|---|---|---|
| [IronClaw](https://github.com/nearai/ironclaw) | Security-focused AI agent by NearAI | 2 GB | 8 GB | 3000 |
| [OpenClaw](https://github.com/openclaw/openclaw) | Personal AI assistant with unified messaging inbox | 2 GB | 8 GB | 18789 |
| [Hermes](https://github.com/nousresearch/hermes-agent) | Self-improving AI agent by Nous Research | 4 GB | 12 GB | — |

## Usage

Run the installer **on your Proxmox host**:

### IronClaw
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/danielporta/proxmox-agent-installer/main/ironclaw-installer.sh)"
```

### OpenClaw
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/danielporta/proxmox-agent-installer/main/openclaw-installer.sh)"
```

### Hermes
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/danielporta/proxmox-agent-installer/main/hermes-installer.sh)"
```

## Post-Installation

### IronClaw
```bash
ironclaw onboard
systemctl start ironclaw
# Web UI: http://<container-ip>:3000
```

### OpenClaw
```bash
openclaw onboard
systemctl start openclaw
# Gateway: http://<container-ip>:18789
```

### Hermes
```bash
hermes model       # LLM-Provider wählen
hermes setup       # vollständiger Setup-Wizard
systemctl start hermes
```

## Repository Structure

```
.
├── ironclaw-installer.sh        # Proxmox host script – IronClaw
├── openclaw-installer.sh        # Proxmox host script – OpenClaw
├── hermes-installer.sh          # Proxmox host script – Hermes
├── install/
│   ├── ironclaw-install.sh      # runs inside LXC container
│   ├── openclaw-install.sh      # runs inside LXC container
│   └── hermes-install.sh        # runs inside LXC container
└── misc/
    └── build.func               # patched build.func (community-scripts fork)
```

## How It Works

1. The installer script runs on the **Proxmox host** and sources `misc/build.func`
2. `build.func` creates the LXC container and pulls the matching `install/<app>-install.sh` from this repo
3. The install script runs **inside the container** and sets up the application

## License

MIT — based on [community-scripts/ProxmoxVE](https://github.com/community-scripts/ProxmoxVE)
