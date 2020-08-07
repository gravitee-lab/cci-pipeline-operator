+++
weight = 20
+++

# The Secret Hub Case

---

## What is Secret Hub ?

Have you ever heard about https://secrethub.io ? Let's play together

* On your everuday dev machine, Install `Secret Hub CLI` [following the official doc instructions](https://secrethub.io/docs/start/getting-started/#install)
* And then execute :
```bash
secrethub signup
```

---

# What just happened ?

* you created a SecretHub user account using the `Secret Hub` REST API
* the `Secret Hub` REST API came out of the std output is the **ROOT TOKEN** for your new Secret Hub account (user) :
  * using this ROOT Token gives full permissions : SO we never ever give anyone that TOKEN
  * we give tokens with only read permissions to pipeline service providers (Cirle Ci, Travis CI,  Gitlab CI)
* A new file was created on your filesystem, `~/.secrethub/credential`, and inside of it, you will find the  **ROOT TOKEN** for your new Secret Hub account persisted.

---

## Create a `Secret Hub` repo

Have you ever heard about https://secrethub.io ? Let's play together

* On your everuday dev machine, Install `Secret Hub CLI` [following the official doc instructions](https://secrethub.io/docs/start/getting-started/#install)
* And then execute :
```bash
# secrethub repo init [options] <namespace>/<repo>
secrethub repo init gravitee-lab/apim-gateway
secrethub account inspect
secrethub account inspect | jq .
```

---

## Write Secrets to `Secret Hub`

Have you ever heard about https://secrethub.io ? Let's play together

* And then execute :
```bash
secrethub mkdir --parents gravitee-lab/apim-gateway/staging/docker/quay/

# write a secret
secrethub write gravitee-lab/apim-gateway/staging/docker/quay/botuser
secrethub write gravitee-lab/apim-gateway/staging/docker/quay/botoken
# read a secret a secret
secrethub read gravitee-lab/apim-gateway/staging/docker/quay/botuser
secrethub read gravitee-lab/apim-gateway/staging/docker/quay/botoken

```

see also The Circle CI example I prepared :
  * [the Circle CI pipeline config](https://github.com/gravitee-lab/gravitee-gateway/blob/8d13fe050ebf99f74f470ad71620f3bc78cf6d70/.circleci/config.yml#L101)
  * [the Circle CI pipeline execution successfull docker push](https://app.circleci.com/pipelines/github/gravitee-lab/gravitee-gateway/37/workflows/b6c84de7-986c-4668-8f64-86936af20f47/jobs/58)

---


## Secret Hub and Secret Management (in Gravitee 's CICD)

* about Secret management : keypass2, secrethub, and hashcorp vault, what architecture for secret management in the Gravitee CICD Global system ?
* All the services already in use in the CI CD Scope : Let's and talk about the Hybrid Cloud nature of the CICD, and CICD Hybrid cloud management.
* CICD Hybrid cloud management and Bots : [why we need bots](https://gravitee-lab-cicd-bot.github.io/post/the-gravitee-lab-ci-cd-bot/), [what are bots](https://gravitee-lab-cicd-bot.github.io/),

---

### Presentation at site root

Create `content/_index.md`:

```markdown
+++
outputs = ["Reveal"]
+++

# Slide 1

Hello world!
```

---

### Add slides

Separate them by `---` surrounded by blank lines:

```
# Slide 1

Hello world!

---

# Slide 2

Hello program!
```

---

### Add slides with other files

Add slides to `content/home/*.md`

```markdown
+++
weight = 10
+++

# Slide 3

---

# Slide 4
```

<small>💡 Tip: Use `weight` to specify the order that files should be considered.</small>

---

### Presentation at '/{section}/'

Add slides to `content/{section}/_index.md`:

```markdown
+++
outputs = ["Reveal"]
+++

# Slide 1

---

# Slide 2
```

---

Add slides from other files in `content/{section}/*.md`

```markdown
+++
weight = 10
+++

# Slide 3

---

# Slide 4
```

<small>💡 Tip: Use `weight` to specify the order that files should be considered.</small>
