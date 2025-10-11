FROM registry.access.redhat.com/ubi9-minimal:latest

LABEL maintainer="Antonio Neri <antoneri@proton.me>" \
      description="SAS Viya | Toolkit Pod"

# Necessary environment variables
ENV LANG="en_US.UTF-8" \
    TZ="Europe/Rome"

# Update and install necessary tools
RUN microdnf update -y && \
    microdnf upgrade -y && \
    rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    rpm -ivh https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm && \
    microdnf install -y --enablerepo=ubi-9-codeready-builder-rpms --setopt install_weak_deps=0 \
    bat \
    bind-utils \
    bzip2 \
    git \
    iputils \
    java-21-openjdk \
    jq \
    krb5-workstation \
    nmap \
    openssh-clients \
    postgresql16 \
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
    # Install yq
    curl -sSL https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o /usr/local/bin/yq && chmod +x /usr/local/bin/yq && \
    # Install icdiff
    pip3 install --no-cache-dir icdiff && \
    # Clean up
    microdnf clean all && \
    rm -rf /tmp/* /var/tmp/* /var/cache/dnf /var/cache/yum

# Create sas user with root privileges
RUN groupadd -g 1001 sas && \
    useradd -ms /bin/zsh -u 1001 -g 1001 sas && \
    usermod -aG wheel sas && \
    echo "sas ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set the user
USER sas

# Copy powerlevel10k settings
COPY /.assets/.p10k.zsh /home/sas/.p10k.zsh

# Customize zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-completions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions && \
    git clone https://github.com/zsh-users/zsh-history-substring-search.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && \
    echo '# zsh' > $HOME/.zshrc && \
    echo 'export PATH=$HOME/bin:/usr/local/bin:$PATH' >> $HOME/.zshrc && \
    echo 'export ZSH="$HOME/.oh-my-zsh"' >> $HOME/.zshrc && \
    echo 'export ZSH_THEME="powerlevel10k/powerlevel10k"' >> $HOME/.zshrc && \
    echo 'plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-completions zsh-history-substring-search nmap)' >> $HOME/.zshrc && \
    echo 'source $ZSH/oh-my-zsh.sh' >> $HOME/.zshrc && \
    echo 'TERM=xterm-256color' >> $HOME/.zshrc && \
    echo '' >> $HOME/.zshrc && \
    echo '# Aliases' >> $HOME/.zshrc && \
    echo 'alias ll="ls -la"' >> $HOME/.zshrc && \
    echo 'alias diff="icdiff"' >> $HOME/.zshrc && \
    echo 'alias please="sudo"' >> $HOME/.zshrc && \
    echo 'alias dnf="microdnf"' >> $HOME/.zshrc && \
    echo '' >> $HOME/.zshrc && \
    echo '# To customize prompt, run `p10k configure` or edit $HOME/.p10k.zsh.' >> $HOME/.zshrc && \
    echo '[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh' >> $HOME/.zshrc

# Set default shell to zsh
SHELL ["/bin/zsh", "-c"]

# Set the working directory
WORKDIR /home/sas

# Default command to run when starting the container
CMD ["/bin/zsh"]
