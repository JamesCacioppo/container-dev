FROM ubuntu:21.04
# Ubuntu 22.04 is not currently supported by Docker

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update \
  && apt install -y --no-install-recommends tzdata \
  && apt install -y git \
  vim \
  curl \
  jq \
  ca-certificates \
  gnupg \
  lsb-release \
  software-properties-common \
  build-essential \
  groff \
  less \
  && rm -rf /bar/lib/apt/lists/*

# Install Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt update && apt install -y docker-ce docker-ce-cli containerd.io

# Install Kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
  && curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" \
  && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
  && kubectl version --client

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
  && chmod 700 get_helm.sh \
  && ./get_helm.sh

# Install Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
  && apt update \
  && apt install terraform

# Install Tilt
RUN curl -fsSL https://github.com/tilt-dev/tilt/releases/download/v0.22.15/tilt.0.22.15.linux.$(uname -m).tar.gz | tar -xzv tilt \
  && mv tilt /usr/local/bin/tilt

# Install AWSCLI

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && ./aws/install

ENTRYPOINT ["bash"]

