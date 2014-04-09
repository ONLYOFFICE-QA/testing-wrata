class Server < ActiveRecord::Base

  has_many :histories

  attr_accessible :address, :description, :name, :comp_name, :_status

  #validates :address, uniqueness: true
  def _status
    self.attributes['_status'].to_sym
  end

end
