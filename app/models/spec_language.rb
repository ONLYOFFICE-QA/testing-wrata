# frozen_string_literal: true

class SpecLanguage < ApplicationRecord
  validates_uniqueness_of :name
end
