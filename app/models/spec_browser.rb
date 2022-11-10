# frozen_string_literal: true

# Model which used to configure which browser is used for running tests
class SpecBrowser < ApplicationRecord
  # @return [String] default value of browser
  DEFAULT = 'default'

  validates :name, uniqueness: true, format: { with: /\A[a-zA-Z]+\z/ }
end
