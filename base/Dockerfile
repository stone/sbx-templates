FROM docker/sandbox-templates:claude-code-docker

ARG GO_VERSION=1.22.4
ARG TREE_SITTER_VERSION=0.26.9

USER root
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  tzdata \
  zlib1g \
  build-essential \
  unzip \
  lua5.4 \
  liblua5.4-dev \
  luarocks \
  && rm -rf /var/lib/apt/lists/* \
  # expose lua/luac under unversioned names
  && ln -sf /usr/bin/lua5.4 /usr/local/bin/lua \
  && ln -sf /usr/bin/luac5.4 /usr/local/bin/luac

USER agent
RUN mkdir -p /home/agent/.local/opt /home/agent/.local/bin

# Go toolchain (user-level).
RUN curl -fsSL -o /tmp/go.tgz "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" \
  && tar -C /home/agent/.local/opt -xzf /tmp/go.tgz \
  && rm /tmp/go.tgz
ENV GOPATH=/home/agent/go
ENV PATH=$PATH:/home/agent/.local/opt/go/bin:/home/agent/go/bin

# Neovim (latest release tarball).
RUN curl -fsSL -o /tmp/nvim.tgz https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
  && tar -C /home/agent/.local/opt -xzf /tmp/nvim.tgz \
  && rm /tmp/nvim.tgz
ENV PATH=$PATH:/home/agent/.local/opt/nvim-linux-x86_64/bin

# tree-sitter CLI (user-level) — required by nvim-treesitter to build parsers.
RUN curl -fsSL "https://github.com/tree-sitter/tree-sitter/releases/download/v${TREE_SITTER_VERSION}/tree-sitter-linux-x64.gz" \
  | gunzip -c > /home/agent/.local/bin/tree-sitter \
  && chmod +x /home/agent/.local/bin/tree-sitter

# Use nvim as vim/vi (so `vim`, `vi` and `nvim` all launch neovim).
RUN ln -sf /home/agent/.local/opt/nvim-linux-x86_64/bin/nvim /home/agent/.local/bin/vim \
  && ln -sf /home/agent/.local/opt/nvim-linux-x86_64/bin/nvim /home/agent/.local/bin/vi

# Agent files: scripts, configs. The whole tree is copied into the home dir.
COPY --chown=agent:agent files/home/agent/ /home/agent/

# Make user bin dirs available in interactive shells.
RUN printf '\nexport PATH="$HOME/bin:$HOME/.local/bin:$PATH"\n' \
  >> /home/agent/.bashrc
