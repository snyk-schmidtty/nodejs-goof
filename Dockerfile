FROM node:14.1.0

# https://support.snyk.io/hc/en-us/articles/4405320307473-Automatically-link-between-Dockerfile-and-images-using-labels
LABEL org.opencontainers.image.source="https://github.com/snyk-schmidtty/goof-github"
# LABEL io.snyk.containers.image.dockerfile="/Dockerfile"

RUN apt-get install -y imagemagick

RUN mkdir /usr/src/goof
RUN mkdir /tmp/extracted_files
COPY . /usr/src/goof
WORKDIR /usr/src/goof

RUN npm update
RUN npm install
EXPOSE 3001
EXPOSE 9229
ENTRYPOINT ["npm", "start"]
