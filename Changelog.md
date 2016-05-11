# Change log

## 1.9
## New features
* Use `--shm-size` option for `docker run` for increasing it. Remove old code for increase shm by runtime.
Need to use docker v1.10.0 or newer for it (https://github.com/docker/docker/pull/16168)
* Add ability to send custom portal name to spec.  It use enviroment variable `SPEC_SERVER_IP`. 
You should implement parsing it in your tests, to correctly run tests on customs ip.
* Add single button to destroy all unbooked servers


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
* Fix problem with reruning test with last parameter #103
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

