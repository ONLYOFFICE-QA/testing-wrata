# Change log

## master
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

### Refactor
* Remove unused `start-icon`
* Reorganize a whole lot managing branches

### Fix
* Use `seeds.rb` to set default `SpecLanguage` to `en-US`
* Fix problems with precompiled image backgrounds
* Possible fix of Connection Pool exceeded
* Redirect from `/singin` if already sign-in (fix [#287](https://github.com/ONLYOFFICE/testing-wrata/issues/287)) 
* Do not insert empty string as custom portal
* Fix cleaning server and client history

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
* Fix server error while calling `servers/show_current_results` for server which not running tests
* Fix server error while calling `servers/show_current_results` for non-existing server
* Fix null element while clicking cancel in custom portal field (fix #226)
* Fix render `RunnderController#updated_data` in browser
* Do not initilize `run_manager` if user is not confirmed
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

* [#157](https://github.com/ONLYOFFICE/testing-wrata/issues/157): Fix showing error if server was deleted
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
* Use `--shm-size` option for `docker run` for increasing it. Remove old code for increase shm by runtime.
Need to use docker v1.10.0 or newer for it (https://github.com/docker/docker/pull/16168)
* Increase `shm-size` to 2 gigabyte
* Docker rm executed containers after finish task
* Add ability to send custom portal name to spec.  It use environment variable `SPEC_SERVER_IP`. 
You should implement parsing it in your tests, to correctly run tests on customs ip.
* Add single button to destroy all unbooked servers
* Add ability to run before spec any command from `/before-run.sh`, not only `sudo mount -a`
* Add button to remove duplicates from Test Queue
* Remove all internal global variables
* Do not try to mount `/mnt/data_share` inside docker. This cause error mentioned in #158 
* Better logging of error in `HTMLResultManager`
* Hide exceeding log output on production environment

### Changes
* Add button for spec file now adds it to beginning of queue, instead of end. Behaviour not changed if add folder
* Remove setting `@create_portal` flag in `portal_data_docs`. It broke stuff if there is custom portal
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
* Ability to run any file, not only `_spec.rb`. Currently only supported `_spec.rb` and generic `.rb` files

## 1.7.1
* Fix order in which project are pulled. If there was new dependencies in `testing-shared` - they will be included in OnlineDocuments

## 1.7.0
* You can use now not only branch, but tags as identificators
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

