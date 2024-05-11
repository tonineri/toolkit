FROM ubuntu:24.04

LABEL version="20240511" \
      maintainer="Antonio Neri <antoneri@proton.me>" \
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
    zip \
    zsh

# Cleanup
RUN apt clean && \
    rm -rf /tmp/* /root/.cache /var/lib/apt/lists/*

# Set default shell to zsh
SHELL ["/bin/zsh", "-c"]

# Create a user with root privileges
RUN useradd -ms /bin/zsh sas && \
    usermod -aG sudo sas && \
    echo "sas ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set the user
USER sas

# Customize zsh
RUN rm -rf $HOME/.oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone https://github.com/jonmosco/kube-ps1.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/kube-ps1
RUN echo 'export PATH=\$HOME/bin:/usr/local/bin:\$PATH' > /home/sas/.zshrc && \
    echo 'export ZSH="\$HOME/.oh-my-zsh"' >> /home/sas/.zshrc && \
    echo 'ZSH_THEME="agnoster"' >> /home/sas/.zshrc && \
    echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting kubectl)' >> /home/sas/.zshrc && \
    echo 'source \$ZSH/oh-my-zsh.sh' >> /home/sas/.zshrc && \
    echo 'TERM=xterm-256color' >> /home/sas/.zshrc && \
    echo 'alias ll="ls -la"' >> /home/sas/.zshrc && \
    echo 'alias bat="batcat"' >> /home/sas/.zshrc && \
    echo 'alias locate="plocate"' >> /home/sas/.zshrc && \
    echo 'alias please="sudo"' >> /home/sas/.zshrc

# Set the working directory
WORKDIR /home/sas

# Default command to run when starting the container
CMD ["/bin/zsh"]  # Change default shell for the CMD
