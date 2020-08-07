#!/bin/bash

# ---
echo "HUGO_PROJECT_NAME=[${HUGO_PROJECT_NAME}]"
hugo version

# setting up baseURL

sed -i "s#baseURL =.*#baseURL = \"${HUGO_BASE_URL}\"#g" /gravitee-bot/src/config.toml
sed -i "s#baseurl =.*#baseURL = \"${HUGO_BASE_URL}\"#g" /gravitee-bot/src/config.toml


# Now building

cd /gravitee-bot/src && rm -fr public
echo "[- ./hugo/:/gravitee-bot/src/] volume folder content before hugo build : "
ls -allh /gravitee-bot/src
ls -allh /gravitee-bot/src/themes
ls -allh /gravitee-bot/src/themes/vec
cd /gravitee-bot/src && hugo
echo "[- ./hugo/:/gravitee-bot/src/] volume folder content after hugo build : "
ls -allh /gravitee-bot/src
echo "Gravitee Bot Doc HUGO SERVER boot"
cd /gravitee-bot/src && hugo server
