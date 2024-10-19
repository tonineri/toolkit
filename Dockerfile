FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

LABEL version="20241019" \
      maintainer="Antonio Neri <antoneri@proton.me>" \
      description="Toolkit Pod"

# Necessary environment variables
ENV LANG="en_US.UTF-8" \
    TZ="Europe/Rome"

# Update and install necessary tools
RUN microdnf update -y && \
    microdnf install -y epel-release && \
    microdnf install -y \
    bat \
    curl \
    git \
    iputils \
    java-17-openjdk \
    krb5-workstation \
    nmap \
    openssh-clients \
    postgresql \
    python3 \
    python3-pip \
    rsync \
    sudo \
    traceroute \
    unzip \
    vim-enhanced \
    wget \
    zip \
    zsh && \
    microdnf clean all

# Install icdiff via pip
RUN pip3 install --no-cache-dir icdiff

# Create a user with root privileges
RUN useradd -ms /bin/zsh sas && \
    usermod -aG wheel sas && \
    echo "sas ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set the user
USER sas

# Customize zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-completions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions && \
    git clone https://github.com/zsh-users/zsh-history-substring-search.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search && \
    git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/you-should-use && \
    git clone https://github.com/jonmosco/kube-ps1.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/kube-ps1 && \
    sed -i 's|# export PATH=$HOME/bin:/usr/local/bin:$PATH|export PATH=$HOME/bin:/usr/local/bin:$PATH|g' $HOME/.zshrc && \
    sed -i 's|robbyrussell|agnoster|g' $HOME/.zshrc && \
    sed -i 's|plugins=(git)|plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-completions zsh-history-substring-search you-should-use kubectl kube-ps1 nmap)|g' $HOME/.zshrc && \
    echo 'TERM=xterm-256color' >> $HOME/.zshrc && \
    echo 'alias ll="ls -la"' >> $HOME/.zshrc && \
    echo 'alias diff="icdiff"' >> $HOME/.zshrc && \
    echo 'alias please="sudo"' >> $HOME/.zshrc && \
    echo 'alias bat="batcat"' >> $HOME/.zshrc

# Set default shell to zsh
SHELL ["/bin/zsh", "-c"]

# Set the working directory
WORKDIR /home/sas

# Default command to run when starting the container
CMD ["/bin/zsh"]
