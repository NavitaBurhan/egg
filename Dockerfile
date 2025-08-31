FROM        --platform=$TARGETOS/$TARGETARCH debian:bookworm-slim

LABEL       author="SkyNest" maintainer="skynest@official.net" \
            org.opencontainers.image.source="https://github.com/skynestoffc/egg"

ENV DEBIAN_FRONTEND=noninteractive

# ===== Update & install dependencies =====
RUN dpkg --add-architecture i386 \
    && apt update \
    && apt upgrade -y \
    && apt install -y \
        wget curl tar unzip zip xz-utils \
        software-properties-common \
        iproute2 dnsutils ca-certificates \
        tzdata fontconfig tini \
        # Wine + libraries 32bit
        wine wine32 wine64 winbind xvfb \
        lib32gcc-s1 lib32stdc++6 \
        libtbb12:i386 libtbb-dev:i386 libicu-dev:i386 \
    && useradd -d /home/container -m container \
    && rm -rf /var/lib/apt/lists/*

# ===== Configure wine prefix =====
USER        container
ENV USER=container HOME=/home/container
WORKDIR     /home/container

# Pre-init wine (biar gak error pertama kali run)
RUN winecfg || true

# ===== Entry point =====
STOPSIGNAL SIGINT

COPY --chown=container:container ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD        ["/entrypoint.sh"]
