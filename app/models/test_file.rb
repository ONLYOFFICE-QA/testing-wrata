# frozen_string_literal: true

# A single spec which will be run
class TestFile < ApplicationRecord
  belongs_to :test_list

  validates :name, presence: true
end
