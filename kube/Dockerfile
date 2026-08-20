FROM base

ARG KUBECTL_VERSION
ARG KIND_VERSION
ARG FLUX_VERSION
ARG GOSS_VERSION
ARG CST_VERSION
ARG AGE_VERSION
ARG SOPS_VERSION

USER agent
RUN mkdir -p /home/agent/.local/bin
ENV PATH=$PATH:/home/agent/.local/bin

# kubectl
RUN curl -fsSL -o /home/agent/.local/bin/kubectl \
  "https://dl.k8s.io/release/v${KUBECTL_VERSION:?}/bin/linux/amd64/kubectl" \
  && chmod +x /home/agent/.local/bin/kubectl

# kind
RUN curl -fsSL -o /home/agent/.local/bin/kind \
  "https://kind.sigs.k8s.io/dl/v${KIND_VERSION:?}/kind-linux-amd64" \
  && chmod +x /home/agent/.local/bin/kind

# flux
RUN curl -fsSL "https://github.com/fluxcd/flux2/releases/download/v${FLUX_VERSION:?}/flux_${FLUX_VERSION}_linux_amd64.tar.gz" \
  | tar -xz -C /home/agent/.local/bin flux \
  && chmod +x /home/agent/.local/bin/flux

# goss + dgoss (dgoss resolves the goss binary via PATH)
RUN curl -fsSL "https://github.com/goss-org/goss/releases/download/v${GOSS_VERSION:?}/goss_${GOSS_VERSION}_linux_x86_64.tar.gz" \
  | tar -xz -C /home/agent/.local/bin goss \
  && curl -fsSL -o /home/agent/.local/bin/dgoss \
  "https://github.com/goss-org/goss/releases/download/v${GOSS_VERSION}/dgoss" \
  && chmod +x /home/agent/.local/bin/goss /home/agent/.local/bin/dgoss

# container-structure-test
RUN curl -fsSL -o /home/agent/.local/bin/container-structure-test \
  "https://github.com/GoogleContainerTools/container-structure-test/releases/download/v${CST_VERSION:?}/container-structure-test-linux-amd64" \
  && chmod +x /home/agent/.local/bin/container-structure-test

# age (age + age-keygen; the tarball nests them under age/)
RUN curl -fsSL "https://github.com/FiloSottile/age/releases/download/v${AGE_VERSION:?}/age-v${AGE_VERSION}-linux-amd64.tar.gz" \
  | tar -xz --strip-components=1 -C /home/agent/.local/bin age/age age/age-keygen \
  && chmod +x /home/agent/.local/bin/age /home/agent/.local/bin/age-keygen

# sops
RUN curl -fsSL -o /home/agent/.local/bin/sops \
  "https://github.com/getsops/sops/releases/download/v${SOPS_VERSION:?}/sops-v${SOPS_VERSION}.linux.amd64" \
  && chmod +x /home/agent/.local/bin/sops
