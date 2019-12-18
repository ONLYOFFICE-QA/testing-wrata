# frozen_string_literal: true

class SpecBrowser < ApplicationRecord
  # @return [String] default value of browser
  DEFAULT = 'default'

  validates :name, uniqueness: true
end
