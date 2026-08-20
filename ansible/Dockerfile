FROM base
ARG ANSIBLE_VERSION
ARG MOLECULE_VERSION
USER agent
ENV PATH=$PATH:/home/agent/.local/bin

RUN curl -fsSL https://astral.sh/uv/install.sh | sh
ENV ANSIBLE_VENV=/home/agent/.local/share/ansible
RUN uv venv --python 3.12 "$ANSIBLE_VENV" \
  && uv pip install --python "$ANSIBLE_VENV/bin/python" \
  "ansible==${ANSIBLE_VERSION:?}" \
  "molecule==${MOLECULE_VERSION:?}" \
  "molecule-plugins[docker]"
RUN for f in "$ANSIBLE_VENV"/bin/ansible* "$ANSIBLE_VENV"/bin/molecule; do \
  ln -sf "$f" "/home/agent/.local/bin/$(basename "$f")"; \
  done
ENV PATH=$ANSIBLE_VENV/bin:$PATH
