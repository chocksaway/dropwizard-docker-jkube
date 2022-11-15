FROM openjdk:17-jdk-slim-buster
MAINTAINER Miles Davenport <milesd@chocksaway.com>

ENV APP_HOME /app

RUN groupadd -r app && useradd -r -gapp app
RUN mkdir -m 0755 -p ${APP_HOME}/bin
RUN mkdir -m 0755 -p ${APP_HOME}/config
RUN mkdir -m 0755 -p ${APP_HOME}/logs

COPY maven/target/dropwizard-docker-jkube.jar ${APP_HOME}/bin
COPY maven/docker-entrypoint.sh /
COPY maven/src/main/resources/config.yml ${APP_HOME}/config
COPY maven/src/main/resources/keystore.pfx ${APP_HOME}

RUN chown -R app:app ${APP_HOME}
RUN chmod +x /docker-entrypoint.sh

EXPOSE 8080
EXPOSE 8081
EXPOSE 8443

WORKDIR ${APP_HOME}
CMD ["/docker-entrypoint.sh"]

