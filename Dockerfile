FROM registry.access.redhat.com/ubi9-minimal:latest

LABEL version="20250223" \
      maintainer="Antonio Neri <antoneri@proton.me>" \
      description="Toolkit Pod"

# Necessary environment variables
ENV LANG="en_US.UTF-8" \
    TZ="Europe/Rome"

# Update and install necessary tools
RUN microdnf update -y && \
    rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    rpm -ivh https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm && \
    microdnf install -y --enablerepo=ubi-9-codeready-builder --setopt install_weak_deps=0 \
    bat \
    bzip2 \
    git \
    iputils \
    java-17-openjdk \
    jq \
    krb5-workstation \
    nmap \
    openssh-clients \
    postgresql15 \
    python3 \
    python3-pip \
    rsync \
    sudo \
    tar \
    unzip \
    vim-enhanced \
    wget \
    zip \
    zsh && \
    microdnf clean all && \
    rm -rf /var/cache/yum /tmp/* /var/tmp/*

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
    echo '# zsh' > $HOME/.zshrc && \
    echo 'export PATH=$HOME/bin:/usr/local/bin:${KREW_ROOT:-$HOME/.krew}/bin:$PATH' >> $HOME/.zshrc && \
    echo 'export ZSH="$HOME/.oh-my-zsh"' >> $HOME/.zshrc && \
    echo 'export AGNOSTER_CONTEXT_BG=black' >> $HOME/.zshrc && \
    echo 'export AGNOSTER_CONTEXT_FG=white' >> $HOME/.zshrc && \
    echo 'export AGNOSTER_DIR_BG=yellow' >> $HOME/.zshrc && \
    echo 'export AGNOSTER_DIR_FG=black' >> $HOME/.zshrc && \
    echo 'export ZSH_THEME="agnoster"' >> $HOME/.zshrc && \
    echo 'plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-completions zsh-history-substring-search you-should-use nmap)' >> $HOME/.zshrc && \
    echo 'source $ZSH/oh-my-zsh.sh' >> $HOME/.zshrc && \
    echo 'TERM=xterm-256color' >> $HOME/.zshrc && \
    echo 'alias ll="ls -la"' >> $HOME/.zshrc && \
    echo 'alias diff="icdiff"' >> $HOME/.zshrc && \
    echo 'alias please="sudo"' >> $HOME/.zshrc && \
    echo 'alias dnf="microdnf"' >> $HOME/.zshrc

# Set default shell to zsh
SHELL ["/bin/zsh", "-c"]

# Set the working directory
WORKDIR /home/sas

# Default command to run when starting the container
CMD ["/bin/zsh"]
