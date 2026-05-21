FROM ubuntu:24.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    openssh-server \
    curl \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure SSH
RUN mkdir /var/run/sshd

# Allow root login via SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Set a default root password (change this!)
RUN echo 'root:changeme' | chpasswd

RUN git config --system core.fileMode true \
    && git config --system init.defaultBranch main

WORKDIR /workspace
VOLUME ["/workspace"]

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
