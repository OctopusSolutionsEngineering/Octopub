# Run from the root directory with
# docker build -f docker/selfcontained/Dockerfile .
FROM eclipse-temurin:17 AS builder

# add pom.xml and source code
ADD java /java
RUN cd /java; ./mvnw install --batch-mode
RUN cd /java/products-microservice; ./mvnw package --batch-mode

# build sbom
RUN cd /java/products-microservice; ./mvnw cyclonedx:makeAggregateBom -DskipTests --no-transfer-progress --batch-mode

RUN apt-get update; apt-get install -y ca-certificates curl gnupg; mkdir -p /etc/apt/keyrings; curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update; apt-get install nodejs -y

RUN npm install --global yarn

ADD js/frontend /js
RUN cd /js; yarn install; yarn build
RUN cd /js; npm install --global @cyclonedx/cyclonedx-npm
RUN cd /js; cyclonedx-npm --ignore-npm-errors --output-file /js/bom.json

FROM nginxinc/nginx-unprivileged
USER root
RUN DEBIAN_FRONTEND=noninteractive \
      apt-get update \
      && apt-get install -y supervisor default-jdk \
      && rm -rf /var/lib/apt/lists/*

COPY --from=builder /js/build /usr/share/nginx/html/
COPY --from=builder /java/products-microservice/target/products-microservice-runner.jar /opt

# Copy the sbom files
RUN mkdir -p /opt/sbom/products-microservice
RUN mkdir -p /opt/sbom/frontend
COPY --from=builder /java/products-microservice/target/bom.json /opt/sbom/products-microservice
COPY --from=builder /js/bom.json /opt/sbom/frontend

COPY docker/selfcontained/nginx.conf /etc/nginx/nginx.conf
COPY docker/selfcontained/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

USER nginx

CMD ["/usr/bin/supervisord"]