class SpecLanguage < ApplicationRecord
  validates_uniqueness_of :name
end
