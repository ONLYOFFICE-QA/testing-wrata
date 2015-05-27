class TestList < ActiveRecord::Base
  attr_accessible :name, :client_id

  belongs_to :client
  has_many :test_files

  validates :name, presence: true,
                   length: { minimum: 3, maximum: 20 }

  # validates :client_id, :presence =>  true
end
