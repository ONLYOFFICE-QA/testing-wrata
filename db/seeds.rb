# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

SpecLanguage.find_or_create_by(name: 'cs-CZ')
SpecLanguage.find_or_create_by(name: 'de-DE')
SpecLanguage.find_or_create_by(name: 'en-US')
SpecLanguage.find_or_create_by(name: 'es-ES')
SpecLanguage.find_or_create_by(name: 'fr-FR')
SpecLanguage.find_or_create_by(name: 'it-IT')
SpecLanguage.find_or_create_by(name: 'pt-BR')
SpecLanguage.find_or_create_by(name: 'ru-RU')

SpecBrowser.find_or_create_by(name: 'chrome')
SpecBrowser.find_or_create_by(name: 'firefox')
