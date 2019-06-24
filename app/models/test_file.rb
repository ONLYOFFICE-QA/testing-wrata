# frozen_string_literal: true

class TestFile < ActiveRecord::Base
  belongs_to :test_list

  validates :name, presence: true
end
