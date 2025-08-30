FROM ubuntu:latest

ARG RUNNER_VERSION="latest"
ARG DEBIAN_FRONTEND=noninteractive

# Create user and install base dependencies
RUN apt update -y && apt upgrade -y && \
    useradd -m docker && \
    apt install -y --no-install-recommends \
        curl jq build-essential libssl-dev libffi-dev \
        python3 python3-venv python3-dev python3-pip \
        libicu-dev \
        ca-certificates \
        git \
        docker.io \
    && rm -rf /var/lib/apt/lists/*

# Set working directory for the runner
WORKDIR /home/docker/actions-runner

# Download and extract GitHub Actions runner
RUN if [ "$RUNNER_VERSION" = "latest" ]; then \
      RUNNER_VERSION=$(curl -s https://api.github.com/repos/actions/runner/releases/latest \
        | jq -r .tag_name | sed 's/^v//'); \
    fi && \
    curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    rm ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Install runner dependencies as root
RUN /home/docker/actions-runner/bin/installdependencies.sh

# Fix ownership
RUN chown -R docker:docker /home/docker

# Copy entrypoint script
COPY start.sh /home/docker/actions-runner/start.sh
RUN chmod +x /home/docker/actions-runner/start.sh

# Switch to non-root user
USER docker

ENTRYPOINT ["/home/docker/actions-runner/start.sh"]
