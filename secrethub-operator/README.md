# What is this

The **Secret Hub Operator** is `Docker Compose` based bot that automates https://secrethub.io operations.

A `Helm Chart` version, instead of Docker Compose, should soon be available.



# How to use

The **Secret Hub Operator** is meant to run on a machine where are installed `git`, `Docker`, `Docker Compose`, `Secret Hub CLI`


On that machine where you want to run the **Secret Hub Operator**, execute these steps :

* _**Prepare Secrets values**_ : first, you will need to give your own values for the quay.io credentials, used by the "Gravitee bot" (the robot user that operates secret hub for the gravitee team): those credentials will be interactively asked for and set by the `benchmark/secrethub-operator/init-secrets.sh` script.

* _**Secret Hub Signup**_
  * [Install the `SecretHub CLI`](https://secrethub.io/docs/reference/cli/install/), and run the interactive `secrethub signup` command :

```bash
jbl@poste-devops-jbl-16gbram:~/cicd-graviteesource/benchmark/secrethub-operator$ secrethub repo init graviteelaby/testrepo
Encountered an error: could not find credential file. Run `secrethub signup` to create an account. (secrethub.credential_not_exist)
jbl@poste-devops-jbl-16gbram:~/cicd-graviteesource/benchmark/secrethub-operator$ secrethub signup
Let's get you setup. Before we continue, I need to know a few things about you. Please answer the questions below, followed by an [ENTER]

The username you'd like to use: graviteebot
Your full name: jean-baptiste-lasselle
Your (work) email address: jean-baptiste.lasselle@graviteesource.com

An account credential will be generated and stored at /home/jbl/.secrethub/credential. Losing this credential means you lose the ability to decrypt your secrets. So keep it safe.
Please enter a passphrase to protect your local credential (leave empty for no passphrase):
Enter the same passphrase again:
Setting up your account......................
Created your account.

Do you want to create a shared workspace for your team? [Y/n]: Y

Workspace name (e.g. your company name): gravitee-lab
A description (max 144 chars) for your team workspace so others will recognize it:
A Secrethub Workspace to test collaboration on SecretHub
Creating your shared workspace...........
Created your shared workspace.

Setup complete. To read your first secret, run:

    secrethub read graviteebot/start/hello

jbl@poste-devops-jbl-16gbram:~/cicd-graviteesource/benchmark/secrethub-operator$ secrethub read graviteebot/start/hello
Welcome jean-baptiste-lasselle! This is your first secret. To write a new version of this secret, run:

    secrethub write graviteebot/start/hello
jbl@poste-devops-jbl-16gbram:~/cicd-graviteesource/benchmark/secrethub-operator$ ls -allh ~/.secrethub/
total 24K
drwx------   2 jbl jbl 4.0K Aug  5 20:42 .
drwxr-xr-x 214 jbl jbl  16K Aug  5 20:42 ..
-rw-------   1 jbl jbl 3.1K Aug  5 20:42 credential
jbl@poste-devops-jbl-16gbram:~/cicd-graviteesource/benchmark/secrethub-operator$ ls -allh ~/.secrethub/credential
-rw------- 1 jbl jbl 3.1K Aug  5 20:42 /home/jbl/.secrethub/credential

```
* running the `secrethub signup` command does this :
  * it creates a new user account on secrethub,
  * returns the root token to authenticate to `SecretHub` : using this token to authenticate, gives all permissions on the newly created `SecretHub` user account. Therefore, this Root Token is to be highly secure.
* So You only need to execute this :

```bash
export DESIRED_VERSION=feature/apim-pipeline
export OPS_HOME=$(mktemp -d)

git clone gitlab.com:second-bureau/missions/gravitee-source/cicd-lab.git ${OPS_HOME}

cd ${OPS_HOME}

git checkout ${DESIRED_VERSION}

cd benchmark/secrethub-operator

./init-secrets.sh

```

_**After Success**_


With https://app.circleci.com/pipelines/github/gravitee-lab/gravitee-gateway/35/workflows/fe310867-16de-4891-a0d5-2a9fbcc39bd1/jobs/53 : in the last step _"Build and pus Docker Image"_ I have solved the SECRETHUB CircleCI integration, I just have to change the value of the secret, to have a sucessful `docker login`. The key parts are :

* make sure circle ci pipeline version is above or equal to `2.1`
* add the SecretHub Circle CI `Orb` import clause to the `./.circleci/config.yml` pipeline definition :

```Yaml
# first line of ./.circleci/config.yml
version: 2.1
orbs:
  secrethub: secrethub/cli@1.0.0
```
* add the SecretHub Install custom command (from the imported Secret Hub Circle CI `Orb`) `- secrethub/install` to the `./.circleci/config.yml` pipeline definition : in the secodn Job, which contains the _"Build and pus Docker Image"_ last step, that executes `secrethub` CLI commands to read the secrets (the token has read permissions on the secrethub repo)

```Yaml
# 3 steps in a job in ./.circleci/config.yml
      - checkout
      - secrethub/install
      - deploy:
          name: Build and push Docker image
          command: |
            APIM_VERSION=6.57.45
            APIM_VERSION=3.1.2
            GIT_COMMIT_ID=${APIM_VERSION}
            GIT_COMMIT_ID=${CIRCLE_BUILD_NUM}
            TAG="0.0.03-apim-${GIT_COMMIT_ID}"
            pwd
            ls -allh
            QUAY_BOT_USERNAME=$(secrethub read gravitee-lab/apim-gateway/staging/docker/quay/botuser/username)
            QUAY_BOT_SECRET=$(secrethub read gravitee-lab/apim-gateway/staging/docker/quay/botoken/token)
            echo "QUAY_BOT_USERNAME=[${QUAY_BOT_USERNAME}]"
            echo "QUAY_BOT_SECRET=[${QUAY_BOT_SECRET}]"
            docker build --no-cache -t "quay.io/gravitee-lab/apim-gateway:${TAG}" -f docker/Dockerfile docker/ --build-arg GRAVITEEIO_VERSION=${APIM_VERSION}
            docker login -u="${QUAY_BOT_USERNAME}" -p="${QUAY_BOT_SECRET}" quay.io
            docker push "quay.io/gravitee-lab/apim-gateway:${TAG}"
            pwd
```

See https://github.com/gravitee-lab/gravitee-gateway/issues/4#issuecomment-669518738
