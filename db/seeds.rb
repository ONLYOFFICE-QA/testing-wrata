# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

SpecLanguage.find_or_create_by(name: 'en-US')
TestedServer.find_or_create_by(url: 'info us')
TestedServer.find_or_create_by(url: 'info eu')
TestedServer.find_or_create_by(url: 'info sg')
TestedServer.find_or_create_by(url: 'com us')
TestedServer.find_or_create_by(url: 'com eu')
TestedServer.find_or_create_by(url: 'com sg')
TestedServer.find_or_create_by(url: 'com org')
TestedServer.find_or_create_by(url: 'default')
TestedServer.find_or_create_by(url: 'custom')
