FROM ubuntu:21.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update \
  && apt install -y --no-install-recommends tzdata \
  && apt install -y git vim curl jq ca-certificates curl gnupg lsb-release \
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



ENTRYPOINT ["bash"]

