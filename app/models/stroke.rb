class Stroke < ActiveRecord::Base
  attr_accessible :name, :number

  belongs_to :test_file
end
