# This is my README

## How to update

```
git pull --prune
docker-compose up -d --no-deps --build app
```

## Credential options

```yaml
secret_key_base: key # secret key
github_user: user # user of github to fetch projects
github_password: pass # password of user
ssh_user: user # username for node
ssh_pass: pass # password for node
```
