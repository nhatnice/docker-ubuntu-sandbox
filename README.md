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
- 💾 **Persistent `/home/ubuntu/workspace` volume** — work survives container restarts
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
  -v workspace:/home/ubuntu/workspace \
  -v ssh_host_keys:/etc/ssh \
  -e ROOT_PASSWORD=yourpassword \
  --name docker-ubuntu-sandbox \
  ghcr.io/nhatnice/docker-ubuntu-sandbox:latest
```

### Connect via SSH

```bash
ssh root@localhost
# password: whatever you set in ROOT_PASSWORD (default: changeme)
```

> ⚠️ **Always set `ROOT_PASSWORD`** before exposing this container to any network.

---

## 🔑 Root Password

The root password is set at container startup via the `ROOT_PASSWORD` environment variable. If not provided, it defaults to `changeme`.

### docker run

```bash
docker run -d -e ROOT_PASSWORD=yourpassword ...
```

### docker-compose

Set it in a `.env` file alongside your `docker-compose.yml`:

```env
ROOT_PASSWORD=yourpassword
```

Or pass it inline:

```bash
ROOT_PASSWORD=yourpassword docker compose up -d
```

---

## 📁 Workspace

The `/home/ubuntu/workspace` directory is the agent's persistent home. Everything written here survives container restarts thanks to a Docker named volume.

---

## 🔐 Security Notes

This sandbox is designed for **development and experimentation**. Before using in any production or networked environment:

- **Always set `ROOT_PASSWORD`** to a strong value via the environment variable
- Add your SSH public key to `/root/.ssh/authorized_keys` and disable password auth entirely
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
  -e ROOT_PASSWORD=devpassword \
  -v $(pwd)/workspace:/home/ubuntu/workspace \
  --name docker-ubuntu-sandbox-dev \
  docker-ubuntu-sandbox
```

---

## 📋 Requirements

- Docker 20.10+

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
