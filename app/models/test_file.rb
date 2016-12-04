class TestFile < ActiveRecord::Base
  belongs_to :test_list
  has_many :strokes

  validates :name, presence: true
end
