#!/bin/bash

# this is the run.sh that is executed as 'Dockerfile' 'CMD [ "/gravitee-bot/run.sh"]'

# secrethub repo init [options] <namespace>/<repo>
secrethub repo init gravitee-lab/apim-gateway

# secrethub mkdir --parents gravitee-lab/apim-gateway/staging/docker/quay/botuser
# secrethub mkdir --parents gravitee-lab/apim-gateway/staging/docker/quay/botoken
secrethub mkdir --parents staging/docker/quay/botuser
secrethub mkdir --parents staging/docker/quay/botoken

read -p "What is your gravitee bot Quay username ? (e.g. 'gravitee-lab+graviteebot') " QUAY_BOT_USERNAME
read -p "What is the value of your gravitee bot Quay TOKEN ? " QUAY_BOT_TOKEN

if [ "x${QUAY_BOT_TOKEN}" == "x" ];
  echo "You must provide a non empty value for your gravitee bot Quay username"
  exit 2
fi;

if [ "x${QUAY_BOT_TOKEN}" == "x" ];
  echo "You must provide a non empty value for your gravitee bot Quay TOKEN"
  exit 3
fi;


echo "${QUAY_BOT_USERNAME}" > .gravitee-bot/.secrets/docker/quay.io/botuser.secret
echo "${QUAY_BOT_TOKEN}" > .gravitee-bot/.secrets/docker/quay.io/botoken.secret

cp ~/.secrethub/credential ./.gravitee-bot/.secrets/.secrethub/credential


docker-compose down --rmi all && docker-compose up --build --force-recreate && docker-compose logs -f

# cat .gravitee-bot/.secrets/docker/quay.io/botuser.secret | secrethub write gravitee-lab/apim-gateway/staging/docker/quay/botuser
# cat .gravitee-bot/.secrets/docker/quay.io/botoken.secret | secrethub write apim-gateway/staging/docker/quay/botoken
