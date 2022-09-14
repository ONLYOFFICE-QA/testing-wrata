# frozen_string_literal: true

class SpecLanguage < ApplicationRecord
  validates :name, uniqueness: true, format: { with: /\A[a-zA-Z-]+\z/ }
end
