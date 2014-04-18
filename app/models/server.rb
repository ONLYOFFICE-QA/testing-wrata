class Server < ActiveRecord::Base

  has_many :histories

  attr_accessible :address, :description, :name, :comp_name, :_status, :book_client_id

  #validates :address, uniqueness: true
  def _status
    self.attributes['_status'].to_sym
  end

  def booked_client
    Client.find(self.book_client_id) if self.book_client_id
  end

  def book(client)
    self.book_client_id = client.id
    self.save
  end

  def unbook
    self.book_client_id = nil
    self.save
  end

end
