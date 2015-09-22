class Server < ActiveRecord::Base
  has_many :histories

  attr_accessible :address, :description, :name, :comp_name, :_status, :book_client_id, :last_test_run_date

  # validates :address, uniqueness: true
  def _status
    attributes['_status'].to_sym
  end

  def booked_client
    Client.find(book_client_id) if book_client_id
  end

  def book(client)
    self.book_client_id = client.id
    save
  end

  def unbook
    self.book_client_id = nil
    save
  end

  def self.sort_servers(servers_array)
    servers_array.sort_by { |s| s.name[/\d+/].to_i }
  end
end
