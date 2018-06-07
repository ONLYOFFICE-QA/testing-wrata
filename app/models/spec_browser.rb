class SpecBrowser < ApplicationRecord
  # @return [String] default value of browser
  DEFAULT = 'default'.freeze

  validates_uniqueness_of :name
end
