# frozen_string_literal: true

# Model to store configure of which language (human language)
# spec should be run with
class SpecLanguage < ApplicationRecord
  validates :name, uniqueness: true, format: { with: /\A[a-zA-Z-]+\z/ }
end
