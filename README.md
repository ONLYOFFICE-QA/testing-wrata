# This is my README

## How to update

```shell script
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

## SSL Setup

By default this repo require SSL certificates to work.  
`./certs/tls.crt` and `./certs/tls.key` should
exists on your host, outside docker  
You can disable it by changing `nginx.conf`

## Troubleshooting

* For `uninitialized constant HtmlWithPassedTime (NameError)`
  error in logs you should add `rspec_passed_time_formatter`
  gem dependency in project file.  
  Since [#857](https://github.com/ONLYOFFICE/testing-wrata/pull/857)
