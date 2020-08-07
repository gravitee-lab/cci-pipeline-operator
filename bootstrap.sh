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
  echo "                  then a commit and push to your git flow feature branch is automatically executed, based on the [COMMIT_MESSAGE] env. var."
  echo "                  when using this option, the following env var. are mandatory :"
  echo ""
  echo "                  COMMIT_MESSAGE :  will define the commit message to git flow feature finish the current feature"
  # echo "                  FEATURE_ALIAS :  will execute the [git flow feature finish ${FEATURE_ALIAS}] command, so must match current branch name, or throws an Error code 17"

}
hugoPackage () {
  if [ -d ./docs ]; then
    rm -fr ./docs
  fi;
  mkdir -p ./docs
  cp -fr $(pwd)/hugo/public/* ./docs
  # sed -i "s#baseURL =.*#baseURL = \"${HUGO_BASE_URL}\"#g" ./docs/config.toml
  # sed -i "s#baseurl =.*#baseURL = \"${HUGO_BASE_URL}\"#g" ./docs/config.toml
}

checkFeatureBranch () {
  export CURRENT_BRANCH=$(git branch -a|grep '*'|awk '{print $2}') && echo "CURRENT_BRANCH=[${CURRENT_BRANCH}]"
  export EXPECTED_FEATURE_BRANCH="feature/${FEATURE_ALIAS}"
  if ! [ "x${CURRENT_BRANCH}" == "x${EXPECTED_FEATURE_BRANCH}" ]; then
    if ! [ "x${CURRENT_BRANCH}" == "xdevelop" ]; then
      echo "FEATURE_ALIAS env. var is set to [${FEATURE_ALIAS}] but current branch name is [${CURRENT_BRANCH}]"
      Usage
      exit 17
    fi;
  fi;
}

# clean up
docker-compose down --rmi all

# Bootstrap project :
docker-compose up -d --build --force-recreate hugo_bootstrap && docker-compose logs hugo_bootstrap && sleep 3s && hugoPackage


echo "Congrats! Your hugo project has been bootstraped : "
echo " ++ the generated sorce code is in the [$(pwd)/hugo] folder"
echo " ++ the generated hugo project has been built and the static content has been copied to the [$(pwd)/docs] folder"
echo ''
echo "So now, all you have to do is to commit and push, to initialiaze your git repo with the source code of your project"


# And now you could do a commit and push (if you're satisfied with the result)
# --
# automatially commit and push to feature branch, using the
# git flow with 'git flow init --defaults' full default configuration
# Should be used only
commitAndPush () {
  # First, we need to reset permissions
  export THATSME=$(whoami)
  sudo chown -R ${THATSME}:${THATSME} ./hugo
  sudo chmod -R a+rw ./hugo
  sudo chown -R ${THATSME}:${THATSME} ./docs
  sudo chmod -R a+rw ./docs

  if [ "x${COMMIT_MESSAGE}" == "x" ]; then
    echo "Your commit message is empty or not set"
    echo "set the COMMIT_MESSAGE env. var. to finish your git flow feature"
    Usage
    exit 7
  fi;

  git add --all && git commit -m "${COMMIT_MESSAGE}" && git push -u origin HEAD

  if [ "x${FEATURE_ALIAS}" == "x" ]; then
    echo "Warning : Your FEATURE_ALIAS is empty or not set"
    echo "set the FEATURE_ALIAS env. var. to finish your git flow feature"
    echo ""
  fi;

  echo "Now to finish your git flow feature you can run : "
  echo "  git flow feature finish ${FEATURE_ALIAS} && git push -u origin --all "
}

# And now you could push to Branch
if [ "x$1" == "x" ]; then
  echo "You did not provide the [--git-flow] option as first argument, commit message is empty or not set"
  echo "set the COMMIT_MESSAGE env. var. to commit and push to your branch and finish your git flow feature"
else
  if ! [ "x$1" == "x--git-flow" ]; then
    # read -p  "DEBUGPOINT JBL ko" DEBUGPOINT
    echo "You provided a first argument an unknown option : the [--git-flow] option is the only allowed value as first argument of [$0]"
    Usage
    exit 9
  else
    # read -p  "DEBUGPOINT JBL ok" DEBUGPOINT
    checkFeatureBranch
    commitAndPush
  fi;
fi;
