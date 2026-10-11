FROM ghcr.io/web-tech-tw/rem:main

WORKDIR /app
ARG NOIRE_FILENAME_SUFFIX
ARG NOIRE_PROMPTS_GIT_URL
ENV PYTHONUNBUFFERED=1

RUN wget -qO /app/noire.pex "https://noire-731a2e.gitlab.io/noire${NOIRE_FILENAME_SUFFIX}.pex" && \
    git clone "${NOIRE_PROMPTS_GIT_URL}" /tmp/factory && \
    mv /tmp/factory/prompts /app/prompts && \
    rm -rf /tmp/factory

CMD ["uv", "run", "noire.pex"]
