FROM base

ARG KUBECTL_VERSION=1.30.2
ARG KIND_VERSION=0.23.0
ARG FLUX_VERSION=2.3.0

USER agent
RUN mkdir -p /home/agent/.local/bin
ENV PATH=$PATH:/home/agent/.local/bin

# kubectl
RUN curl -fsSL -o /home/agent/.local/bin/kubectl \
  "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
  && chmod +x /home/agent/.local/bin/kubectl

# kind
RUN curl -fsSL -o /home/agent/.local/bin/kind \
  "https://kind.sigs.k8s.io/dl/v${KIND_VERSION}/kind-linux-amd64" \
  && chmod +x /home/agent/.local/bin/kind

# flux
RUN curl -fsSL "https://github.com/fluxcd/flux2/releases/download/v${FLUX_VERSION}/flux_${FLUX_VERSION}_linux_amd64.tar.gz" \
  | tar -xz -C /home/agent/.local/bin flux \
  && chmod +x /home/agent/.local/bin/flux
