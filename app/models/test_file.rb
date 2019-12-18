# frozen_string_literal: true

class TestFile < ApplicationRecord
  belongs_to :test_list

  validates :name, presence: true
end
