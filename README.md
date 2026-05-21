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
  -v ssh_host_keys:/var/lib/ssh-host-keys \
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

Copy `.env.example` to `.env` and fill in your values:

```bash
cp .env.example .env
```

```env
ROOT_PASSWORD=yourpassword
SSH_PUBLIC_KEY=ssh-ed25519 AAAA... your_email@example.com
```

Or pass inline:

```bash
ROOT_PASSWORD=yourpassword docker compose up -d
```

---

## 🗝️ SSH Key Authentication

Key-based auth is more secure than passwords. Pass your public key via `SSH_PUBLIC_KEY` and it will be written to `/root/.ssh/authorized_keys` at startup.

### 1. Get your public key

```bash
cat ~/.ssh/id_ed25519.pub
# or
cat ~/.ssh/id_rsa.pub
```

If you don't have a key yet, generate one:

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

### 2. Pass the key to the container

**docker run:**

```bash
docker run -d \
  -p 2222:22 \
  -v ssh_host_keys:/var/lib/ssh-host-keys \
  -v ssh_authorized_keys:/root/.ssh \
  -v workspace:/home/ubuntu/workspace \
  -e ROOT_PASSWORD=yourpassword \
  -e SSH_PUBLIC_KEY="$(cat ~/.ssh/id_ed25519.pub)" \
  --name docker-ubuntu-sandbox \
  ghcr.io/nhatnice/docker-ubuntu-sandbox:latest
```

**docker-compose:** add the key to your `.env` file:

```env
SSH_PUBLIC_KEY=ssh-ed25519 AAAA... your_email@example.com
```

Then start:

```bash
docker compose up -d
```

### 3. Connect without a password

```bash
ssh -p 2222 root@localhost
```

> The `authorized_keys` file is stored in the `ssh_authorized_keys` named volume so it persists across container restarts. Updating `SSH_PUBLIC_KEY` and restarting the container will overwrite it with the new key.

---

## 📁 Workspace

The `/home/ubuntu/workspace` directory is the agent's persistent home. Everything written here survives container restarts thanks to a Docker named volume.

---

## 🔐 Security Notes

This sandbox is designed for **development and experimentation**. Before using in any production or networked environment:

- **Always set `ROOT_PASSWORD`** to a strong value via the environment variable
- Set `SSH_PUBLIC_KEY` to your public key and disable password auth (`PasswordAuthentication no`) for stronger security
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
