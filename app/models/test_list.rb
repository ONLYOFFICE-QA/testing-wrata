# frozen_string_literal: true

class TestList < ApplicationRecord
  belongs_to :client
  has_many :test_files

  validates :name, presence: true,
                   length: { minimum: 3, maximum: 20 }
end
