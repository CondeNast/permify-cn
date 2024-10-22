# FROM golang:1.23.2-alpine3.20@sha256:9dd2625a1ff2859b8d8b01d8f7822c0f528942fe56cfe7a1e7c38d3b8d72d679 as permify-builder
# WORKDIR /go/src/app
# RUN apk update && apk add --no-cache git
# COPY . .
# RUN --mount=type=cache,target=/root/.cache/go-build --mount=type=cache,target=/go/pkg/mod CGO_ENABLED=0 go build -v ./cmd/permify/

# FROM cgr.dev/chainguard/static:latest@sha256:d07036a3beff43183f49bce5b2a0bd945f2ffe6e76f734ebd040059a40d371bc
# COPY --from=ghcr.io/grpc-ecosystem/grpc-health-probe:v0.4.28 /ko-app/grpc-health-probe /usr/local/bin/grpc_health_probe
# COPY --from=permify-builder /go/src/app/permify /usr/local/bin/permify
# ENV PATH="$PATH:/usr/local/bin"
# ENTRYPOINT ["permify"]
# CMD ["serve"]


# Use the official Golang image for building the project
FROM golang:1.20 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod and go.sum files to download dependencies
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the rest of the source code into the container
COPY . .

# Build the Permify binary
RUN go build -o permify ./cmd/permify/main.go

# Use a smaller base image for the final container
FROM debian:buster-slim

# Install necessary tools
RUN apt-get update && apt-get install -y ca-certificates curl && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV PORT=8080
ENV PING_PATH=/ping

# Expose port 8080 for the service
EXPOSE 8080

# Set the working directory
WORKDIR /app

# Copy the built binary from the builder stage
COPY --from=builder /app/permify /app/permify

# Healthcheck to ping the /ping endpoint
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s \
    CMD curl --fail http://localhost:8080/ping || exit 1

# Run Permify with the appropriate configuration
CMD ["/app/permify", "serve", "--http-port", "8080"]
