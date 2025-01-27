FROM eclipse-temurin:21

# Set working directory
WORKDIR /photon

# Install pbzip2
RUN apt-get update \
    && apt-get -y install \
        pbzip2 \
        wget \
    && rm -rf /var/lib/apt/lists/*

# Use an environment variable for the release version
ARG PHOTON_VERSION=0.5.0
ENV PHOTON_RELEASE_URL=https://github.com/komoot/photon/releases/download/${PHOTON_VERSION}/photon-${PHOTON_VERSION}.jar

# Add Photon JAR
ADD ${PHOTON_RELEASE_URL} /photon/photon.jar

# Copy the entrypoint script
COPY entrypoint.sh ./entrypoint.sh

# Define a volume for Photon data
VOLUME /photon/photon_data

# Expose port 2322 for Photon service
EXPOSE 2322

# Set entrypoint to the script
ENTRYPOINT ["/bin/sh", "/photon/entrypoint.sh"]
