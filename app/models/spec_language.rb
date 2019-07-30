# frozen_string_literal: true

class SpecLanguage < ApplicationRecord
  validates :name, uniqueness: true
end
