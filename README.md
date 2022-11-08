# wrata

This project is used to run scripts on distributed network with parallel execution

## How it works

Basically workflow consists of several simple steps:

1. Creating DigitalOcean droplets (`Server` class model in project code)
with specified count.
Count of servers depends of tasks.
Some projects has a small number of rspec files,
so 1-5 droplets is enough
Some of them got 10000s of specs and requires 10s of droplets
2. Adding `rspec` files from project to test list with specified parameters
(testing server url, language, browser, etc...)
3. Each of those `rspec` files are run on one of droplets,
chosen from free one in queue
4. After each of `rspec` files are finished - servers can be turn-off manually
or via non-active timeout (Default 1 hour)

## How to update

This should be done after ~1 hour after merging PR to master
Because this [task](https://github.com/ONLYOFFICE/testing-wrata/blob/46786484e8ba852c3af6321e2889b949448776e5/.github/workflows/docker-hub-push.yml#L1)
will create docker hub image with name `onlyofficeqa/wrata:latest`
and this task is not very fast

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

## How to update `nginx` container

```shell
docker-compose stop
docker-compose rm web
docker-compose pull web
docker-compose up -d
```

## How to backup database

```shell
docker-compose exec db pg_dumpall -c -U postgres | gzip > dump_$(date +"%Y-%m-%d_%H_%M_%S").gz
```

## How to restore database backup

```shell
docker-compose stop app
zcat dump*.gz | docker exec -i testing-wrata_db_1 psql -U postgres
docker-compose start app
```

## Troubleshooting

* For `uninitialized constant HtmlWithPassedTime (NameError)`
  error in logs you should add `rspec_passed_time_formatter`
  gem dependency in project file.  
  Since [#857](https://github.com/ONLYOFFICE/testing-wrata/pull/857)

## How to release new version (for maintainers)

1. Update `VERSION` file
2. Update `CHANGELOG.md` by adding version line after `master (unreleased)`
3. Create PR with those changes and merge to `master`
4. On `master` run `rake add_repo_tag`
5. On `GitHub` create new release via web-browser and add info from `CHANGELOG.md`
