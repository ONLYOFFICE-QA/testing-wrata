class Server < ActiveRecord::Base

  has_many :histories

  attr_accessible :address, :description, :name, :comp_name

  #validates :address, uniqueness: true

end
