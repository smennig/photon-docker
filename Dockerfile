FROM amazoncorretto:21

WORKDIR /photon

# Use an environment variable for the release version
ARG PHOTON_VERSION=0.5.0
ENV PHOTON_RELEASE_URL=https://github.com/komoot/photon/releases/download/${PHOTON_VERSION}/photon-${PHOTON_VERSION}.jar

ADD ${PHOTON_RELEASE_URL} /photon/photon.jar
COPY entrypoint.sh ./entrypoint.sh

VOLUME /photon/photon_data
EXPOSE 2322

ENTRYPOINT ["/bin/sh", "/photon/entrypoint.sh"]
