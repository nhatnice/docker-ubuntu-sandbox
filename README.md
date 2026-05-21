# 🤖 AI Agent Sandbox

A lightweight, containerized workspace designed for AI Agents to operate autonomously. Built on Ubuntu 24.04, this sandbox provides a persistent, SSH-accessible environment where agents can clone repositories, run scripts, manage files, and execute tasks — all within an isolated and reproducible Docker container.

---

## 🎯 Purpose

Modern AI Agents need a safe, controlled environment to perform real work: writing and running code, interacting with Git repositories, managing files, and executing shell commands. This project provides exactly that — a ready-to-use sandbox that any agent can connect to via SSH and treat as its own workspace.

---

## ✨ Features

- 🐳 **Docker-based** — fully isolated, reproducible, and easy to spin up anywhere
- 🔧 **Git pre-installed** — agents can clone, commit, push, and pull out of the box
- 🔐 **SSH access on port 22** — connect any agent or client remotely
- 💾 **Persistent `/workspace` volume** — work survives container restarts
- 📦 **Auto-published to GHCR** — GitHub Actions builds and pushes the image on every release

---

## 🚀 Quick Start

### Pull the image

```bash
docker pull ghcr.io/nhatnice/docker-ubuntu-sandbox:latest
```

### Run the sandbox

```bash
docker run -d \
  -p 22:22 \
  -v agent_workspace:/workspace \
  --name docker-ubuntu-sandbox \
  ghcr.io/nhatnice/docker-ubuntu-sandbox:latest
```

### Connect via SSH

```bash
ssh root@localhost
# default password: changeme
```

> ⚠️ **Change the default password** before exposing this container to any network.

---

## 📁 Workspace

The `/workspace` directory is the agent's persistent home. Everything written here survives container restarts thanks to a Docker named volume.

---

## 🔐 Security Notes

This sandbox is designed for **development and experimentation**. Before using in any production or networked environment:

- Change the root password or disable password auth entirely
- Add your SSH public key to `/root/.ssh/authorized_keys`
- Consider creating a non-root user for the agent
- Restrict `PermitRootLogin` in `/etc/ssh/sshd_config`

---

## 🛠️ Local Development

### Build the image locally

```bash
docker build -t docker-ubuntu-sandbox .
```

### Run with a bind mount (for easier file access during development)

```bash
docker run -d \
  -p 2222:22 \
  -v $(pwd)/workspace:/workspace \
  --name docker-ubuntu-sandbox-dev \
  docker-ubuntu-sandbox
```

---

## 📋 Requirements

- Docker 20.10+

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
