# Copyright 2025 Brick Towers

# Accept base image version as a build argument
ARG PROOF_SERVER_VERSION=4.0.0
# Accept file range as a build argument
ARG CIRCUIT_PARAM_RANGE="10 11 12 13 14 15 16 17"

FROM alpine:latest AS downloader
RUN apk add --no-cache curl

COPY fetch-zk-params.sh /fetch-zk-params.sh
RUN chmod +x /fetch-zk-params.sh && \
    CIRCUIT_PARAM_RANGE="10 11 12 13 14 15 16 17" ZK_PARAMS_DIR="/zk-params" /fetch-zk-params.sh

FROM midnightnetwork/proof-server:${PROOF_SERVER_VERSION}
COPY --from=downloader /zk-params /.cache/midnight/zk-params
