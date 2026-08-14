FROM node:24-trixie-slim

WORKDIR /app
ARG NOIRE_FILENAME_SUFFIX
ARG NOIRE_PROMPTS_GIT_URL
ENV PYTHONUNBUFFERED=1

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates git-core wget && \
    mkdir -p /app && cd /app && \
    wget -qO - "https://astral.sh/uv/install.sh" | UV_INSTALL_DIR="/usr/local/bin" sh - && \
    wget -qO - "https://noire-731a2e.gitlab.io/commit-revision" && \
    wget -qO .python-version "https://noire-731a2e.gitlab.io/.python-version" && \
    wget -qO config.example.yaml "https://noire-731a2e.gitlab.io/config.example.yaml" && \
    wget -qO noire.pex "https://noire-731a2e.gitlab.io/noire${NOIRE_FILENAME_SUFFIX}.pex" && \
    uv init --bare && uv sync && rm -rf /var/lib/apt/lists/* && \
    git clone "${NOIRE_PROMPTS_GIT_URL}" /tmp/factory && \
    mv /tmp/factory/prompts /app/prompts && \
    rm -rf /tmp/factory

CMD ["uv", "run", "noire.pex"]
