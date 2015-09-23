class Server < ActiveRecord::Base
  EXECUTOR_IMAGE_NAME = 'nct-at-docker'

  has_many :histories

  attr_accessible :address, :description, :name, :comp_name, :_status, :book_client_id, :last_activity_date, :executing_command_now

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

  def cloud_server_create
    update_column(:_status, :creating)
    begin
      $digital_ocean.restore_image_by_name(EXECUTOR_IMAGE_NAME, name)
    rescue => e
      update_column(:_status, :destroyed)
      raise e
    end
    $digital_ocean.wait_until_droplet_have_status(name)
    new_address = $digital_ocean.get_droplet_ip_by_name(name)
    update_column(:address, new_address)
    update_column(:_status, :created)
    update_column(:last_activity_date, Time.current)
  end

  def cloud_server_destroy
    update_column(:_status, :destroying)
    $digital_ocean.destroy_droplet_by_name(name)
    update_column(:_status, :destroyed)
  end

  def self.sort_servers(servers_array)
    servers_array.sort_by { |s| s.name[/\d+/].to_i }
  end
end
