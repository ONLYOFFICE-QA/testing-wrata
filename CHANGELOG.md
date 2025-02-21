# Change log

## master (unreleased)

### Fixes

* Workaround a bug for failing build on arm64
* Fix `rubocop-1.72.0` cop `Lint/CopDirectiveSyntax`
* Run `rubocop` in CI through `bundle exec`
* Fix missing `yaml-dev` since Docker image upgrade to `ruby:3.4.2-alpine`

### Changes

* Fix minor code issue found by `rubocop-1.70.0`

## v1.31.0 (2025-01-03)

### New Features

* Use `ruby-3.4` as base for application
* Add `hadolint` check to CI
* Add `github-actions` check in Dependabot
* Add additional entries about project update start and stop in run log

### Changes

* Upgrade rails to `rails-7.2.1.1`
* Remove several unused constants
* `Rails.application.credentials.admin_email` is now an array of
  `Rails.application.credentials.admin_emails` to have several admins
* Change Docker Hub organization from `onlyofficeqa` to `onlyoffice`
* Do not install `test` gem dependencies in production
* Remove useless bundler caching from Dockerfile
* Dramatically reduce docker image size by using multistage build
* Fix `rubocop-capybara-2.20.0` warnings
* Remove extra docker step to install bundler
* Actualize `rails_helper` to fix Rails warnings
* Fix rubocop `Layout/EmptyLineAfterMagicComment` cop
* Fix `rubocop-1.63.1` warnings
* Fix `rubocop-1.64` cop `Style/SuperArguments` warnings.
* Actualize JS dependencies
* Update rubocop config to support v3 of `rubocop-rspec`
* Increase image restore check interval to reduce DO api load
* Remove obsolete `version` field from `docker-compose.yml`
* Freeze `postgres` container with specific major version (`13`)
* Upgrade `geckodriver` from `v0.33.0` to `v0.35.0`

### Fixes

* Fix log spam for `git describe` for shallow copy of repo
* Fix missing `public/pack` directory in Docker image
* Fix warning for `docker build` about case of `AS` statement
* Fix line colors in server results page

## v1.30.0 (2022-10-31)

### New Feature

* Ability to measure test coverage via `simplecov`

### Changes

* Remove `minitest-rails` dependency
* Increase test coverage
* Change title for `info` window
* Remove `net-*` requirements, which not needed any more on `ruby-3.1`
* Explicitly add `rspec` gem as test dependency
* Add new migration to fix rubocop `Rails/UniqueValidationWithoutIndex`

### Fixes

* Fix history client name position
* Properly cache `wrata_version` value

## v1.29.0 (2022-09-05)

### New Features

* Add `CI` action to build docker image

### Changes

* Use already built docker image in `docker-compose`
* Actualize `yarn` dependencies
* Add some validation for `Project`, `SpecBrowser`, `SpecLanguage` models

### Fixes

* Fix failures on `server_history` for unknown server id
* Fix errors while calling `http://hot/runner/index`
* Add 403 error when someone try to be redirected from login page
* Log failure on saving run information to DB, but not crash application
* Force read log file in UTF-8 encoding

## v1.28.0 (2022-07-14)

### New Features

* Add `Queue#add_tests` POST endpoint
* Migrate to `WebPacker`
* Add `WebDriver` tests wit `capybara`
* Add `jshint` check in CI

### Changes

* Do not fail if GitHub is not initialized for some reason
* Do not crash frontend if Initializers are not loaded
* Fix `rubocop-1.28.1` code issues
* Refactor `TestList#destroy_with_client_cleanup`
* Rename badly named variable for `ClientTestQueue`
* Remove unused `change_test_location` method and endpoint
* Drop `ruby-3.0` support
* Explicitly require `sassc-rails` dependency
* Migrate to `terser` from deprecated `UglifyJS`
* Actualize `jshint` config and fix some issues
* Remove dependency of `jQuery` gems, they are now in `yarn`

### Fixes

* Fix almost all non-GET/POST request with require of `jquery-ujs`
* Fix failure on opening test list on history page
* Fix typo in html structure
* Fix incorrect font assets path
* Fix language bar position on 1366x768 screen

## 1.27.0 (2022-03-31)

### New Features

* Add `ruby-3.0` to CI
* Add `yamllint` in CI

### Changes

* Fix minor rubocop issue after upgrade rubocop to `v1.24.0`
* Fix migration issues after upgrade `rubocop-rspec` to `v2.13.0`
* Remove `ruby-2.7` from CI, since we use `ruby-3.0` for base
* Use `ruby:3.1.0-alpine` as base image
* Migrate autoloader to `:zeitwerk`
* Update rails framework default from v5.1 to v6.1
* Actualize `nodejs` version in CI
* Migrate to `rails-7` and it's configuration defaults
* Check `dependabot` at 8:00 Moscow time daily
* Fix `rubocop-rails` issues after upgrade to `rubocop-rails v2.14.0`

### Fixes

* Fix `mail` related startup problem on `ruby-3.1`

## 1.26.0 (2021-12-08)

### New Features

* Add `CodeQL` check in CI
* Add version info in footer
* Add `VERSION` file in root of project

### Fixes

* Fix failure when `EOFError` happened during html result read
* Fix several `Stored cross-site scripting`

### Changes

* Do not show detailed stack of error in production
* Major refactor in source code file path to be in complain with `zeitwerk`

## 1.25.0 (2021-09-17)

### New Features

* Add logging to `stdout` in dev environment
* Add description how to run `docker-compose` locally
* Add ability to download all log files for Client
* Force usage of `TSLv1.2` and `TLSv1.3` on https configuration
* Wait for SSH up until showing server node as turned on

### Fixes

* Fix ApiKeys command on Firefox
* Do not hard crash if some user is lost for DelayRun

### Changes

* Use `alpine` as base image for app
* Fix several issues with Dockerfile using `hadolint`
* Store db data in volume for `docker-compose`.
  **Warning** Backup your db data before upgrading
* Improve ssl config by enable session cache and disabling weak ciphers
* Actualize rubocop configs and minor changes to code
* Remove `./script` directory, since new rails project do not use it

## 1.24.1 (2021-06-11)

### Fixes

* Fix broken `DelayRun` change time methods

## 1.24.0 (2021-06-08)

### New Features

* Add instruction to README how to update `nginx` container

### Changes

* Increase puma and db thread count from 50
* Update `bootstrap` to v5

## 1.23.0 (2021-04-20)

### New Features

* Add `login` field to api config file page

### Changes

* Send full region string (like `com us`) in `SPEC_REGION` env

## 1.22.0 (2021-04-05)

### New Features

* Add `ruby-3.0` to CI
* Send notification if `spec` finished run without single test
* Add `dependabot` config for default Dockerfile updates

### Changes

* `Servers`, `Run History` and `API Keys` links in user dropdown
  will open in new tab
* Upgrade to Rails 6.1
* Reduce production log level to `:warn`
* Do not install development gems in production Docker
* Split `test` and `development` gem groups
* Enable http2 for default server
* Set ruby version to `ruby 3.0.0` in default Dockerfile

### Fixes

* Fix error on clicking rspec results for non-rspec files
* Fix `sed` error for test start script for custom service url
* Fix service failure if `LogManager#read_log` fail with incorrect encoding
* Gracefully handle failure on trying to look for rspec-results
* Correct `from` field for failure messages

## 1.21.0 (2020-12-02)

### New Features

* Add test log to `SpecFailed` mail notification

### Fixes

* Fix call `rspec` command in gem somehow outdated

### Changes

* Fixes from `rubocop` update to `1.4.0`
* Send email notification not from gmail, but custom sender in secrets
* Change `Changelog.md` to `CHANGELOG.md`

## 1.20.0 (2020-11-21)

### New Features

* Option to return flatten file list in `GET /runner/file_list`
* `/clients/api_keys` page now provide command with path to file
* Get current user info by `GET /profile`
* Add `rubocop` check in CI
* Add support of `rubocop-minitest`
* Add support of `rubocop-rspec`

### Fixes

* Retest button now add test with all correct params
* Fix `/clinets/api_keys` command if key folder not exists
* Fix rendering example in Rspec's html
* Fix service failure if `History#notify_failure` cannot send mail
* Remove extra unused css rules for `.history-log`
* Fix css problem with history table is too width
* Fix error with using non-actual nodejs with `markdownlint`
* Fix server restart on `ArgumentError` for parsing test result

### Changes

* Remove useless `DelayRun#f_type`
* Remove some more unused code
* Simplify some erb files by moving to partials
* Change default nginx config to use SSL
* Store `certs` inside project folder
* Use `nginx:alpine` image to reduce size
* Use Github Actions instead of travis-ci
* Use dependabot config, not service config
* Fixes from update `rubocop` to `v1.3.0`
* Fixes from update `rubocop-performance` to `v1.9.0`

## 1.19.0 (2020-04-24)

### New Features

* Access nodes via password
* Remove ability to login to node via ssh key
* Actualize Bundler to v.2
* Store `action_mailer.smtp_settings` in secret credentials
* Store `admin_email` in secret credentials
* Remove deprecated secrets keys
* `onlyoffice_digitalocean_wrapper`,
  `onlyoffice_github_helper`,
  `onlyoffice_rspec_result_parser` installed from gem, not github
* Minor cleanup of routes
* Update `rails` to version 6
* `markdownlint` support in travis

### Fixes

* Fix problem with known host with ssh login
* Hide real ssh pass on `server_history` page
* Fix docker-compose with actual version of postgresql
* Fix warning for using `open` instead of `URI.open`

### Changes

* Remove hidden unused files
* Remove `devise#secret_key` - it's replaced by `RAILS_MASTER_KEY`
* Remove table columns for deprecated projects
* Remove all workaround for home path
* Remove `sudo` for commands inside node container
* Speedup travis test by not installing not-needed gems

## 1.18.0 (2020-01-30)

### New features

* Update `sprockets` to version 4
* Remove `mock_cloud_server` config option
* Store `github` access data in credentials
* `config/master.key` in `.dockerignore`

### Fixes

* Fix memory leak on clear history
* Remove unused `ssh/config` and `ssh/id_rsa.pub`

## 1.17.1 (2019-06-24)

### Fixes

* Fix selecting branch for Delay Runs

## 1.17.0 (2019-06-24)

### New features

* Ability to set `SPEC_BROWSER` to tests via env variables
* Ability to set `SPEC_REGION` to test via env variable
* Ability to set progress color according to test results (including Pending status)
* Ability to send environment variables to docker run command
* Ability to run any `.sh` file from project
* Support any number of projects to run tests
* Do not stop change branches if any branch non exists
* Store `Projects` as model, not as config parameter
* Update not only two project on run command, but all
* Correctly use path for any project name
* Use `font-awesome` instead of `glyphicons`
* Upgrade to Bootstrap 4
* Upgrade to Nodejs 10
* Upgrade to Rails 5.2
* Use ruby 2.6 as base docker image

### Fixes

* Fix silent fail if timeout while restoring image
* Catch some more errors while reading test progress
* Fix crash in thread operation while reading non-existing log
* Fix server status in edit page
* Do not require login in test environment
* Fix adding DelayRun with empty `spec_browser`

### Refactor

* Simplified, cleaner `navbar` style
* Simplify `header` erb code

## 1.16.0 (2018-05-30)

### New features

* Add several new lags to SpecLanguage
* Destroy only droplet with specified tag
* Show progress overlay for `runner/stop_current`
* Update app to Ruby 2.5.0
* Add autocomplete login description
* Add restart of docker services
* Set production log level as `:info`
* Use default logger formatter
* Set server status as `select`

### Refactor

* Simplify logic of showing current log in Server window
* Use partial for `loading_overlay`
* Make `unbookAllServers` async
* Make `clearHistory` for client and server async
* Make `remove_duplicates`, `clear_tests`, `remove_duplicates` for queue async
* Remove login form from header (it was duplicated in main window)
* Remove support of `Strokes` (single test cases in Spec)
* Remove duplicate unbook button and simplify CSS
* Centering elements in login page

### Fixes

* Fix broken `fetch-ip` button in server details
* Fix empty logs caused by `Server_destroyer_worker`
* Fix connection leak in `HTMLResultManager#read_progress`
* Fix not closing file in `LogManager#read_log`
* Fix booking already booked server by someone
* Fix leftovers of Histories after deleting them
* Fix critical stop on `read_progress` for several exceptions
* Fix critical crash if log file for server is lost

## 1.15.0

### New features

* `SpecLanguage#name` should be uniq
* `SpecLanguage` view show sorted items
* Remove usage of `/mnt/data_share`
* Show `HtmlResult#page_url`, `HtmlResult#screenshot` in separate div from `message`

### Fixes

* Fix XSS on `show_html_results.html`

## 1.14.0

### New features

* Precompile assets in production
* Use `jQuery` version 3, instead of first one
* Update to Rails 5.1
* Increase puma threads count
* Add highlight for files in file-tree
* Add margin between add-button-file and filename
* Show `spec_language` in current running test tooltip (fix [#286](https://github.com/ONLYOFFICE/testing-wrata/issues/286))
* Add default value to `http://` to custom portal (fix [#283](https://github.com/ONLYOFFICE/testing-wrata/issues/283))
* Add new features - creating servers multiple by name pattern
* Add link to servers page in top toolbar dropdown
* Restyling: change all colors
* Ability to run projects on different branches
* Ability to select multiple `SpecLanguage` at once
* Add `SpecLanguage` to `ServerHistory` page
* Do not hide start options on `ServerHistory` page
* Use `bootbox.confirm` instead of JS native `confirm`
* Store spec exit status and send notification only if failed
* Use nginx in `docker-compose`
* Add `api_keys` page with list of api access keys
* Add start time to `ServerHistory` page (fix [#325](https://github.com/ONLYOFFICE/testing-wrata/issues/325))

### Refactor

* Remove unused `start-icon`
* Reorganize a whole lot managing branches
* Remove forced rvm sourced command from starting test
* Remove duplicate class `ServerOptions`

### Fix

* Use `seeds.rb` to set default `SpecLanguage` to `en-US`
* Fix problems with precompiled image backgrounds
* Possible fix of Connection Pool exceeded
* Redirect from `/singin` if already sign-in
  (fix [#287](https://github.com/ONLYOFFICE/testing-wrata/issues/287))
* Do not insert empty string as custom portal
* Fix cleaning server and client history
* Fix redirect loop for non-verified clients
* Fix copy server IP by click
* Fix using custom branches while adding folder
* Fix scroll lags by deleting `slimscroll` plugin
* Fix long machine name undercutting in DO (fix [#294](https://github.com/ONLYOFFICE/testing-wrata/issues/294))

## 1.13

### New features

* Ability to mock actions with cloud server (good for development)
* Add ability to send custom language to spec.  It use environment variable `SPEC_LANGUAGE`
* Show `spec_language` in queue (implement #231)
* Hide create/destroy server button while operation in progress
* `updated_data` return logs only if called for it
* Use `onlyoffice_github_helper` for file list
* Show web page in single column if width < 1680px
* Use `net-ping` gem instead of sluggish native Linux exec

### Fixes

* Fix problem with manual destroying server, booked by other client
* Do not call `ensure_logs_folder_present` in test env
* Fix server error while calling `servers/show_current_results`
  for server which not running tests
* Fix server error while calling `servers/show_current_results`
  for non-existing server
* Fix null element while clicking cancel in custom portal field (fix #226)
* Fix render `RunnderController#updated_data` in browser
* Do not initialize `run_manager` if user is not confirmed
* Speed-up of FrontEnd

## 1.12

### New features

* Use bootbox alert instead of pure JS for changing branches
* Ability to set DO server size on server creation
* Copy ip of server to clipboard on click

### Bug Fixes

* Fix server error while showing html result for spec with zero specs

## 1.11

### New features

* Upgrade to rails 5
* Send notification to admin if test stopped without result
* Send notification to admin if some exception is happened
* Admin should verify all new users, no need in secret password
* History page now show execution time of run
* Reorganize Test Queue column - show branches
* Remove log window in histories - make page open 3 times faster
* Remove `analyzed` flag from history, it wasn't used for a while
* Hide `Show More` button if there is no more histories entries

### Bug fixes

* Deprecation warning for `config.serve_static_files`
* Sorting list of booked servers
* Fix problem with showing incorrect project file in tabs
* Fix setting server status if it has name with dot
* Fix server error if no start options in history after press `Show More`
* Do not raise server error, while creating delay run if there is no lists

### Refactor

* Remove useless code for stopping browser before docker stop

## 1.10

### New features

* Ability to download log file from `server_history` page
* Ability to specify host name for started docker container
* Tag all created servers with same tag, easy to find them

### Bug fixes

* [#157](https://github.com/ONLYOFFICE/testing-wrata/issues/157):
  Fix showing error if server was deleted
* Fix showing `Already up-to-date` in refs list.

### Refactor

* Remove usage of `protected_attributes` in favor of stronger parameters

### Removal

* Unused methods to reboot servers

## 1.9.1

### Fixes

* Typo in DelayRun RunManager initialization

## 1.9

### New features

* Use `--shm-size` option for `docker run` for
  increasing it. Remove old code for increase shm by runtime.
  Need to use docker v1.10.0 or newer for it [docker#16168](https://github.com/docker/docker/pull/16168)
* Increase `shm-size` to 2 gigabyte
* Docker rm executed containers after finish task
* Add ability to send custom portal name to spec.
  It use environment variable `SPEC_SERVER_IP`.
  You should implement parsing it in your tests,
  to correctly run tests on customs ip.
* Add single button to destroy all unbooked servers
* Add ability to run before spec any command from
  `/before-run.sh`, not only `sudo mount -a`
* Add button to remove duplicates from Test Queue
* Remove all internal global variables
* Do not try to mount `/mnt/data_share` inside docker.
  This cause error mentioned in #158
* Better logging of error in `HTMLResultManager`
* Hide exceeding log output on production environment

### Changes

* Add button for spec file now adds it to beginning of queue,
  instead of end. Behaviour not changed if add folder
* Remove setting `@create_portal` flag in `portal_data_docs`.
  It broke stuff if there is custom portal
* Remove not-helpful logging of Thread events

### Fixes

* Fix problem with checkout of tag and running `git pull` after that
* Fix showing `Already up-to-date` in branches list
* Fix fetching branch info for `TeamLab` project
* Fix issue with new lin of Server list (#149)
* Fix hanging page issue while pull branches of projects
* Fix not hiding overlay for changing branches
* Do not change position of test progress if user unbook server
* All stderr output should be in log file

## 1.8

### New features

* Test list now shown not only `spec` and `RSpec` folder, but all project folders
* Ability to run any file, not only `_spec.rb`.
  Currently only supported `_spec.rb` and generic `.rb` files

## 1.7.1

* Fix order in which project are pulled.
  If there was new dependencies in `testing-shared` -
  they will be included in OnlineDocuments

## 1.7.0

* You can use now not only branch, but tags as identifier
* Ensure, that webserver can be run on `puma` server (Was already included in Gemfile)
* Update Gemfile.lock version of files

## 1.6.2

* Force delete ALL running containers while starting tests
* Rework handling DO keys. Now keys can be changed during runtime of server.
  Also incorrect keys will no longer crash server

## 1.6.1

* Add ability to disable self-destruction of servers

## 1.6

* Fix problem with re-running test with last parameter #103
* Add ability to show links, url and native html from parsed rspec results
* Add more info on server view page
* Add fetch ip button to server edit page
* Do not stop RunThreadManager in any cases. Always check for delayed runs
* Add default values for DelayedRuns view - each time

## 1.5.4.1

* Minor changes in internal logic of DelayedRun

## 1.5.4

* Fix booking servers after auto-destroy AGAIN

## 1.5.3

* Add info about branches in info popup. Fix #98

## 1.5.2

* Fix booking servers after auto-destroy

## 1.5.1

* Fix turning off booked servers

## 1.5

* Fix collapsing navbar on mobile devices (small screens)
* Add ability to get last test run date for each server
* Servers will turn off after specific amount of time of inactivity

## 1.4.2

* Remove executed containers, that no need. They took a lot of space
