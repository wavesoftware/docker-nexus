ARG VERSION=3.42.0
# ARG PUPPET_VERSION=0.1.6
# FROM registry.access.redhat.com/ubi8/ubi-minimal as downloader
# ARG PUPPET_VERSION
# WORKDIR /
# RUN curl -L https://repo1.maven.org/maven2/org/sonatype/nexus/plugins/nexus-repository-puppet/${PUPPET_VERSION}/nexus-repository-puppet-${PUPPET_VERSION}.jar \
#   -o /nexus-repository-puppet.jar
# RUN curl -L https://repo1.maven.org/maven2/org/sonatype/nexus/plugins/nexus-repository-puppet/${PUPPET_VERSION}/nexus-repository-puppet-${PUPPET_VERSION}.jar.asc \
#   -o /nexus-repository-puppet.jar.asc
# # Key fingerprint: 80900DA1952D7C7968F3CFD98C79C4D0382A0E3A
# RUN curl -L 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x80900da1952d7c7968f3cfd98c79c4d0382a0e3a' \
#   -o 80900DA1952D7C7968F3CFD98C79C4D0382A0E3A.asc
# RUN gpg2 --import 80900DA1952D7C7968F3CFD98C79C4D0382A0E3A.asc
# RUN gpg2 --trusted-key 8C79C4D0382A0E3A \
#   --verify nexus-repository-puppet.jar.asc \
#   nexus-repository-puppet.jar
FROM registry.access.redhat.com/ubi8/openjdk-8 as builder
USER root
RUN microdnf install -y git
USER jboss
RUN git clone \
  --branch upgrade/3.42.0 \
  --depth 1 \
  https://github.com/wavesoftware/nexus-repository-puppet.git
WORKDIR /home/jboss/nexus-repository-puppet
RUN ./mvnw clean package
# ARG VERSION
FROM docker.io/sonatype/nexus3:$VERSION
# COPY --from=downloader \
#   /nexus-repository-puppet.jar \
#   /opt/sonatype/nexus/deploy/nexus-repository-puppet.jar
COPY --from=builder \
  /home/jboss/nexus-repository-puppet/target/nexus-repository-puppet-0.1.16-SNAPSHOT.jar \
  /opt/sonatype/nexus/deploy/nexus-repository-puppet.jar