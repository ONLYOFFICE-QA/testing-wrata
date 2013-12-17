class TestFile < ActiveRecord::Base
  attr_accessible :name, :stroke_numbers#, :file_list_id

  belongs_to :test_list
  has_many :strokes

  validates :name, :presence => true

  #validates :file_list_id, :presence => true

end
