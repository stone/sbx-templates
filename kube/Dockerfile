FROM base

ARG KUBECTL_VERSION=1.36.3
ARG KIND_VERSION=0.32.0
ARG FLUX_VERSION=2.9.4
ARG GOSS_VERSION=0.4.10
ARG CST_VERSION=1.22.1

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

# goss + dgoss (dgoss resolves the goss binary via PATH)
RUN curl -fsSL "https://github.com/goss-org/goss/releases/download/v${GOSS_VERSION}/goss_${GOSS_VERSION}_linux_x86_64.tar.gz" \
  | tar -xz -C /home/agent/.local/bin goss \
  && curl -fsSL -o /home/agent/.local/bin/dgoss \
  "https://github.com/goss-org/goss/releases/download/v${GOSS_VERSION}/dgoss" \
  && chmod +x /home/agent/.local/bin/goss /home/agent/.local/bin/dgoss

# container-structure-test
RUN curl -fsSL -o /home/agent/.local/bin/container-structure-test \
  "https://github.com/GoogleContainerTools/container-structure-test/releases/download/v${CST_VERSION}/container-structure-test-linux-amd64" \
  && chmod +x /home/agent/.local/bin/container-structure-test
