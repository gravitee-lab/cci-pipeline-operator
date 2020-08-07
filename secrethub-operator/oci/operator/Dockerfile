FROM node:14.7.0-alpine3.11
# later : https://hub.docker.com/r/secrethub/cli
# secrethub repo init [options] <namespace>/<repo>
ARG SECRETHUB_NAMESPACE=graviteeio
ENV SECRETHUB_NAMESPACE=${SECRETHUB_NAMESPACE}
ARG SECRETHUB_REPO=apim-gw
ENV SECRETHUB_REPO=${SECRETHUB_REPO}



# So inside a Docker node/alpine container
RUN apk update \
  && apk add ca-certificates && rm -rf /var/cache/apk/* \
	&& update-ca-certificates \
  && apk add curl bash \
  && curl -fsSL https://alpine.secrethub.io/pub -o /etc/apk/keys/secrethub.rsa.pub \
  && apk add --repository https://alpine.secrethub.io/alpine/edge/main secrethub-cli
RUN secrethub --version
# [...]
RUN mkdir /gravitee-bot
RUN mkdir /gravitee-bot/.secrets


COPY run.sh /gravitee-bot
RUN chmod +x /gravitee-bot/run.sh

VOLUME [ "/gravitee-bot/.secrets" ]

WORKDIR /gravitee-bot

CMD [ "/gravitee-bot/run.sh" ]
