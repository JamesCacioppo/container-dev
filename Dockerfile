FROM ubuntu:21.04

# Install minimum tools to execute install-container.sh
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /root
RUN apt update \
  && apt install -y --no-install-recommends tzdata \
  && apt install -y git \
  zsh \
  curl \
  vim \
  curl \
  ca-certificates \
  gnupg \
  lsb-release \
  software-properties-common \
  build-essential \
  groff \
  less \
  unzip \
  pip \
  iproute2 \
  dnsutils \
  mtr \
  && rm -rf /var/lib/apt/lists/*

# Set ZSH as default shell
RUN chsh -s $(which zsh)

# Install OhMyZsh
RUN chmod g-w,o-w /usr/local/share/zsh \
  && chmod g-w,o-w /usr/local/share/zsh/site-functions \
  && export ZSH="$HOME/.oh-my-zsh" \
  && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Clone dotfiles repo and link files
RUN git clone https://github.com/JamesCacioppo/mydotfiles.git /root/mydotfiles \
  && if [ -f /root/.zshrc ]; then rm -f /root/.zshrc; fi \
  && ln -sv /root/mydotfiles/linux.zshrc /root/.zshrc \
  && ln -sv /root/mydotfiles/.bash_profile /root/.bash_profile \
  && ln -sv /root/mydotfiles/.gitconfig /root/.gitconfig \
  && ln -sv /root/mydotfiles/.vimrc /root/.vimrc

# Install Brew
RUN echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" > /dev/null \
  && echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /root/.zshrc \
  && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Bundle Install
WORKDIR /root/mydotfiles
RUN /home/linuxbrew/.linuxbrew/bin/brew bundle install --file=Brewfile.container
RUN /home/linuxbrew/.linuxbrew/bin/brew link docker

# Install AWSCLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && ./aws/install \
  && rm awscliv2.zip

# Install OhMyTmux
RUN git clone https://github.com/JamesCacioppo/.tmux.git /root/.tmux \
  && ln -sv /root/.tmux/.tmux.conf /root/tmux.conf \
  && ln -sv /root/.tmux/.tmux.conf.local /root/tmux.conf.local

# Install Vim-Plug, Vundle, and plugins
RUN curl -fsSLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
RUN [ "/bin/bash", "-c", "vim +'PlugInstall --sync' +qa" ]
RUN [ "/bin/bash", "-c", "vim +'PluginInstall --sync' +qa" ]

# Configure Poetry autocompletion
RUN mkdir /root/.oh-my-zsh/custom/plugins/poetry \
  && /home/linuxbrew/.linuxbrew/bin/poetry completions zsh > /root/.oh-my-zsh/custom/plugins/poetry/_poetry

ENTRYPOINT ["zsh"]
