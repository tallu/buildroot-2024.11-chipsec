# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Set non-interactive frontend for apt to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install essential packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        git \
        file \
        cpio \
        unzip \
        bc \
        rsync \
        libncurses-dev \
        ca-certificates \
        curl \
        wget \
        vim \
        sudo \
        python \
        python3 \
        sshpass \
        iputils-ping \
        && apt-get clean && \
        rm -rf /var/lib/apt/lists/*

# Add a user account, give sudo access
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# Set default command to bash
CMD ["/bin/bash"]
