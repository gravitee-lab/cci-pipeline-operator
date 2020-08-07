FROM klakegg/hugo:0.74.3-alpine
# https://github.com/klakegg/docker-hugo

ARG HUGO_VERSION=graviteeio

ARG HUGO_BASE_URL
ENV HUGO_BASE_URL=${HUGO_BASE_URL}

ARG HUGO_THEME_GIT_URI
ENV HUGO_THEME_GIT_URI=${HUGO_THEME_GIT_URI}



# Will provide the secrets to the container from the outside world
RUN mkdir -p /gravitee-bot/.secrets
# Will provide the source code to the external IDE
RUN mkdir -p /gravitee-bot/src
RUN mkdir -p /gravitee-bot/work

COPY hugo-bootstrap.sh /gravitee-bot
RUN chmod +x /gravitee-bot/hugo-bootstrap.sh

RUN apk update && apk add curl bash git

VOLUME /gravitee-bot/.secrets
VOLUME /gravitee-bot/src


WORKDIR /gravitee-bot/work
ENTRYPOINT [ "/gravitee-bot/hugo-bootstrap.sh" ]
