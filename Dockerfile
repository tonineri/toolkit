FROM ubuntu:24.04

LABEL version="20240509" \
      maintainer="Antonio Neri <Antonio.Neri@sas.com>" \
      description="Toolkit Pod"

# Necessary environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ="Europe/Rome"

# Update packages and install necessary tools
RUN apt-get update && \
    apt-get install -y \
    bat \
    curl \
    expect \
    git \
    inetutils-ping \
    jq \
    krb5-user \
    netcat-openbsd \
    nmap \
    plocate \
    postgresql-client \
    python3 \
    python3-pip \
    rsync \
    sudo \
    telnet \
    unzip \
    wget \
    zip

# Cleanup
RUN apt clean && \
    rm -rf /tmp/* /root/.cache /var/lib/apt/lists/*

# Set default shell to bash
SHELL ["/bin/bash", "-c"]

# Create a user with root privileges
RUN useradd -ms /bin/bash sas && \
    usermod -aG sudo sas && \
    echo "sas ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set the user
USER sas

# Set aliases for sas
RUN echo 'TERM=xterm-256color' >> /home/sas/.bashrc && \
    echo 'alias ll="ls -la"' >> /home/sas/.bashrc && \
    echo 'alias bat="batcat"' >> /home/sas/.bashrc && \
    echo 'alias locate="plocate"' >> /home/sas/.bashrc && \
    echo 'alias please="sudo"' >> /home/sas/.bashrc

# Set the working directory
WORKDIR /home/sas

# Default command to run when starting the container
CMD ["/bin/bash"]
