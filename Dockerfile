# Filename: Dockerfile

ARG USER_HOME_DIR="/root"

FROM timbru31/java-node:jdk-18-hydrogen
WORKDIR "/ngafid2.0"
COPY . ./
RUN apt-get -y update && apt-get -y install git php php-mysql mysql-client


RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
 && curl -fsSL -o /tmp/apache-maven.tar.gz https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz \
 && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
 && rm -f /tmp/apache-maven.tar.gz \
 && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

RUN apt-get install openssh-server sudo -y && \
	systemctl enable ssh

#RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 user
RUN  echo 'root:ngafid' | chpasswd 
RUN  sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
#RUN chmod -R 777 /ngafid2.0

RUN mvn install:install-file initialize -Dfile=src/main/resources/DAT2CSV-1.0.jar -DgroupId=org.ngafid -DartifactId=dat2csv -Dpackaging=jar -Dversion=1.0


ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

#RUN npm install --legacy-peer-deps && mvn install -DskipTests

RUN sh create_db_files.sh

EXPOSE 8081
EXPOSE 80
EXPOSE 22


ENTRYPOINT sh entrypoint.sh
