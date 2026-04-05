# Copyright (c) 2024-2026 Magnon Compute Corporation. All Rights Reserved.
# -----------------------------------------------------------------------------
# The base image for building the k9s binary
FROM --platform=$BUILDPLATFORM golang:1.25.5-alpine3.21 AS build

ARG TARGETOS
ARG TARGETARCH
ENV GOOS=$TARGETOS
ENV GOARCH=$TARGETARCH

WORKDIR /k9s
COPY go.mod go.sum main.go Makefile ./
COPY internal internal
COPY cmd cmd
RUN apk --no-cache add --update make libx11-dev git gcc libc-dev curl \
  && make build

# -----------------------------------------------------------------------------
# Build the final Docker image
FROM --platform=$BUILDPLATFORM alpine:3.23.0
ARG KUBECTL_VERSION="v1.32.2"

COPY --from=build /k9s/execs/k9s /bin/k9s
RUN apk --no-cache add --update ca-certificates \
  && apk --no-cache add --update -t deps curl vim \
  && TARGET_ARCH=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) \
  && curl -f -L https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${TARGET_ARCH}/kubectl -o /usr/local/bin/kubectl \
  && chmod +x /usr/local/bin/kubectl \
  && apk del --purge deps
# Run as non-root user
RUN addgroup --system --gid 65534 nonroot && \
    adduser --system --uid 65534 --gid 65534 --no-create-home nonroot
USER nonroot
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:${PORT:-8080}/health/live || exit 1

ENTRYPOINT [ "/bin/k9s" ]
