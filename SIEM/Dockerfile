FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Install required dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    docker.io \
    docker-compose \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create UTMStack directory
WORKDIR /opt/utmstack

# Download UTMStack installer
RUN wget -O installer http://github.com/utmstack/UTMStack/releases/latest/download/installer && \
    chmod +x installer

# Expose UTMStack ports
EXPOSE 443 9200 5044 514/udp 514/tcp

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f https://localhost:443 || exit 1

# Run UTMStack installer
ENTRYPOINT ["./installer"]
