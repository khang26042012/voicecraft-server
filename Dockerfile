# VoiceCraft.Server Dockerfile - built from source
FROM mcr.microsoft.com/dotnet/sdk:9.0.108-bookworm-slim AS build
WORKDIR /src

# Install git to clone
RUN apt-get update && apt-get install -y git ca-certificates && rm -rf /var/lib/apt/lists/*

# Clone source
ARG VERSION=v1.7.1
RUN git clone --depth 1 --branch $VERSION https://github.com/AvionBlock/VoiceCraft.git /src/voicecraft

# Build
WORKDIR /src/voicecraft/VoiceCraft.Server
RUN dotnet publish -c Release -r linux-x64 --self-contained true -o /app/build /p:PublishSingleFile=false

# Runtime
FROM mcr.microsoft.com/dotnet/runtime:9.0.8-bookworm-slim
WORKDIR /app
COPY --from=build /app/build /app

# Default ports
EXPOSE 9050/udp

# Run
CMD ["./VoiceCraft.Server"]
