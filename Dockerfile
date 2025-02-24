FROM --platform=$TARGETPLATFORM docker.io/library/node:16-alpine

ARG TARGETPLATFORM
ARG BUILDPLATFORM

ARG S6_OVERLAY_VERSION=3.1.6.2
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

RUN echo "Building for TARGETPLATFORM=$TARGETPLATFORM | BUILDPLATFORM=$BUILDPLATFORM"
RUN apk add --no-cache git jq python3 make gcc musl-dev g++ && \
    rm -rf /var/lib/apt/lists/*
RUN git clone --recurse-submodules https://gitlab.com/RemixDev/deemix-gui.git
WORKDIR deemix-gui
RUN case "$TARGETPLATFORM" in \
        "linux/amd64") \
            jq '.pkg.targets = ["node16-alpine-x64"]' ./server/package.json > tmp-json ;; \
        "linux/arm64") \
            jq '.pkg.targets = ["node16-alpine-arm64"]' ./server/package.json > tmp-json ;; \
        *) \
            echo "Platform $TARGETPLATFORM not supported" && exit 1 ;; \
    esac && \
    mv tmp-json /deemix-gui/server/package.json
RUN yarn install-all
# Patching deemix: see issue https://github.com/youegraillot/lidarr-on-steroids/issues/63
RUN sed -i 's/const channelData = await dz.gw.get_page(channelName)/let channelData; try { channelData = await dz.gw.get_page(channelName); } catch (error) { console.error(`Caught error ${error}`); return [];}/' ./server/src/routes/api/get/newReleases.ts
RUN yarn dist-server
RUN mv /deemix-gui/dist/deemix-server /deemix-server

RUN chmod +x /deemix-server

COPY deemix-server.sh /
RUN chmod +x /deemix-server.sh

VOLUME ["/deemix-gui/config", "/downloads"]
EXPOSE 6595
ENTRYPOINT /deemix-server.sh
