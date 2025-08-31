FROM debian:bullseye-slim

LABEL author="Ridwan Host" maintainer="your-email@example.com"
LABEL description="SAMP Server (Windows) via Wine for Pterodactyl"

ENV DEBIAN_FRONTEND=noninteractive \
    WINEDEBUG=-all \
    WINEPREFIX=/wine \
    WINEARCH=win32 \
    USER=container

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    wine32 wine64 xvfb curl unzip tar git ca-certificates \
    lib32gcc-s1 lib32stdc++6 && \
    useradd -m -d /home/container -s /bin/bash ${USER} && \
    rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /home/container && chown -R ${USER}:${USER} /home/container

USER ${USER}
WORKDIR /home/container

# Entrypoint untuk Pterodactyl
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
