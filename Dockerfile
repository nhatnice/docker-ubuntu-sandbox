FROM ubuntu:24.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install base packages + GitHub CLI repo key
RUN apt-get update && apt-get install -y \
    git \
    openssh-server \
    curl \
    vim \
    python3 \
    python3-pip \
    python3-venv \
    gnupg \
    unzip \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update && apt-get install -y gh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js LTS via NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:$PATH"

# Configure SSH
RUN mkdir /var/run/sshd

# Allow root login via SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

RUN git config --system core.fileMode true \
    && git config --system init.defaultBranch main

RUN mkdir -p /var/lib/ssh-host-keys
VOLUME ["/var/lib/ssh-host-keys"]

RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh
VOLUME ["/root/.ssh"]

WORKDIR /home/ubuntu/workspace
VOLUME ["/home/ubuntu/workspace"]

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV ROOT_PASSWORD=changeme

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
