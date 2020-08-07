#!/bin/bash

source .env
Usage () {
  echo "---"
  echo "- [$0] launches a container that bootstrap a hugo project, based on the hugo theme specified with the ${HUGO_THEME_GIT_URI} env. var."
  echo "- [$0] will then : "
  echo "       place the generated source code of the hugo project in the [$(pwd)/hugo] folder."
  echo "       hugo build the hugo project, and the hugo generated static assets are placed into the [$(pwd)/docs] folder, with baseURL cofigured in [config.toml]"

  echo "       Hit [Ctrl + C] to exit [docker-compose logs -f], and the hugo source code will optionnally be "
  echo "       pushed to your feature branch using the git flow, see [--git-flow] option. "
  echo "---"
  echo "- Usage :"
  echo "---"
  echo "  $0 [options]"
  echo "---"
  echo "- Options :"
  echo "    --git-flow    if you provide this options invoking [$0] , then When you Ctrl + C to exit [docker-compose logs -f] "
  echo "                  then a git flow release is automatically executed, based on the [NEXT_RELEASE] env. var. in the [.env] file"
  echo "                  when using this option, the following env var. are mandatory :"
  echo ""
  echo "                  COMMIT_MESSAGE :  will define the commit message to git flow feature finish the current feature"
  # echo "                  FEATURE_ALIAS :  will execute the [git flow feature finish ${FEATURE_ALIAS}] command, so must match current branch name, or throws an Error code 17"
}
echo "Implementation not finished"
Usage
exit 0

hugoPackage () {
  if [ -d ./docs ]; then
    rm -fr ./docs
  fi;
  mkdir -p ./docs
  cp -fr $(pwd)/hugo/public/* ./docs
  sed -i "s#baseURL =.*#baseURL = \"${HUGO_BASE_URL}\"#g" ./docs/config.toml
  sed -i "s#baseurl =.*#baseURL = \"${HUGO_BASE_URL}\"#g" ./docs/config.toml
}
# Develop cycle :
docker-compose up -d --build --force-recreate hugo_ide && sleep 5s && hugoPackage

docker-compose logs -f hugo_ide

# Congrats! Now the fresh hugo project source code is generated under the [src/] folder, and your site runing at

# And now you could do a release

if [ "x${COMMIT_MESSAGE}" == "x" ]; then
  echo "Your commit message is empty or not set"
  echo "set the COMMIT_MESSAGE env. var. to finish your git flow feature"
  exit 7
fi;

git add --all && git commit -m "${COMMIT_MESSAGE}" && git push -u origin HEAD

if [ "x${FEATURE_ALIAS}" == "x" ]; then
  echo "Your FEATURE_ALIAS is empty or not set"
  echo "set the FEATURE_ALIAS env. var. to finish your git flow feature"
  echo ""
fi;

git flow feature finish ${FEATURE_ALIAS} && git push -u origin --all && git push -u origin --tags

git flow release start ${NEXT_RELEASE}
git flow release finish -s ${NEXT_RELEASE}
