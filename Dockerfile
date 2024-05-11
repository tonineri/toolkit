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
    language-pack-en \
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
    vim \
    wget \
    zip \
    zsh

# Cleanup
RUN apt clean && \
    rm -rf /tmp/* /root/.cache /var/lib/apt/lists/*

# Create a user with root privileges
RUN useradd -ms /bin/zsh sas && \
    usermod -aG sudo sas && \
    echo "sas ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set the user
USER sas

# Customize zsh
RUN rm -rf $HOME/.oh-my-zsh && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    git clone https://github.com/jonmosco/kube-ps1.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/kube-ps1 && \
    sed -i 's|# export PATH=$HOME/bin:/usr/local/bin:$PATH|export PATH=$HOME/bin:/usr/local/bin:$PATH|g' $HOME/.zshrc && \
    sed -i 's|robbyrussell|agnoster|g' $HOME/.zshrc && \
    sed -i 's|plugins=(git)|plugins=(git zsh-autosuggestions zsh-syntax-highlighting kubectl)|g' $HOME/.zshrc && \
    echo 'TERM=xterm-256color' >> $HOME/.zshrc && \
    echo 'alias ll="ls -la"' >> $HOME/.zshrc && \
    echo 'alias bat="batcat"' >> $HOME/.zshrc && \
    echo 'alias locate="plocate"' >> $HOME/.zshrc && \
    echo 'alias please="sudo"' >> $HOME/.zshrc

# Set default shell to zsh
SHELL ["/bin/zsh", "-c"]

# Set the working directory
WORKDIR /home/sas

# Default command to run when starting the container
CMD ["/bin/zsh"]
