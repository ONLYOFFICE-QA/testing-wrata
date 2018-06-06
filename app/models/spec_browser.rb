class SpecBrowser < ApplicationRecord
  validates_uniqueness_of :name
end
