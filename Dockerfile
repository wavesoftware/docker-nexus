ARG VERSION=3.42.0
ARG PUPPET_VERSION=0.1.6
FROM registry.access.redhat.com/ubi8/ubi-minimal as downloader
ARG PUPPET_VERSION
WORKDIR /
RUN curl -L https://repo1.maven.org/maven2/org/sonatype/nexus/plugins/nexus-repository-puppet/${PUPPET_VERSION}/nexus-repository-puppet-${PUPPET_VERSION}.jar \
  -o /nexus-repository-puppet.jar
RUN curl -L https://repo1.maven.org/maven2/org/sonatype/nexus/plugins/nexus-repository-puppet/${PUPPET_VERSION}/nexus-repository-puppet-${PUPPET_VERSION}.jar.asc \
  -o /nexus-repository-puppet.jar.asc
# Key fingerprint: 80900DA1952D7C7968F3CFD98C79C4D0382A0E3A
RUN gpg2 --keyserver keyserver.ubuntu.com \
  --recv-keys 80900DA1952D7C7968F3CFD98C79C4D0382A0E3A
RUN gpg2 --trusted-key 8C79C4D0382A0E3A \
  --verify nexus-repository-puppet.jar.asc \
  nexus-repository-puppet.jar
FROM docker.io/sonatype/nexus3:$VERSION
COPY --from=downloader \
  /nexus-repository-puppet.jar \
  /opt/sonatype/nexus/deploy/nexus-repository-puppet.jar
