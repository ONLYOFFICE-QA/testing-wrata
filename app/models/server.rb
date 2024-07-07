# frozen_string_literal: true

# A single DigitalOcean server which used for running tests
class Server < ApplicationRecord
  include ServerTestOut
  EXECUTOR_IMAGE_NAME = 'nct-at-docker'
  EXECUTOR_TAG = 'nct-at'
  DEFAULT_SERVER_SIZE = '1gb'
  STATUSES_TO_MANUAL_SET = %i[destroyed created].freeze
  # @return [Integer] interval in seconds for checking image restore status
  CLOUD_IMAGE_RESTORE_INTERVAL = 20

  has_many :histories

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

  def cloud_server_create(server_size)
    server_size ||= DEFAULT_SERVER_SIZE
    update_column(:_status, :creating)
    restore_image_and_wait(server_size)
    update_column(:_status, :created)
    update_column(:size, server_size)
    update_column(:last_activity_date, Time.current)
  end

  def cloud_server_destroy
    unbook
    update_column(:_status, :destroying)
    destroy_and_wait_for_it
    Runner::Application.config.run_manager.remove_server(name)
    update_column(:_status, :destroyed)
    update_column(:executing_command_now, false)
  end

  def self.sort_servers(servers_array)
    servers_array.sort_by { |s| s.name[/\d+/].to_i }
  end

  # @return [String] ip of current server.
  def fetch_ip
    RunnerManagers.digital_ocean.get_droplet_ip_by_name(name)
  end

  private

  # Set ip info depending of mocking
  def set_ip_info
    new_address = RunnerManagers.digital_ocean.get_droplet_ip_by_name(name)
    update_column(:address, new_address)
  end

  # Start creation and wait for it
  def restore_image_and_wait(server_size)
    begin
      RunnerManagers.digital_ocean.restore_image_by_name(EXECUTOR_IMAGE_NAME,
                                                         name,
                                                         'nyc3',
                                                         server_size,
                                                         tags: EXECUTOR_TAG)
    rescue StandardError => e
      update_column(:_status, :destroyed)
      raise e
    end
    RunnerManagers.digital_ocean.wait_until_droplet_have_status(name,
                                                                'active',
                                                                timeout: 60 * 15,
                                                                interval: CLOUD_IMAGE_RESTORE_INTERVAL)
    set_ip_info
    OnlyofficeDigitaloceanWrapper::SshChecker.new(address).wait_until_ssh_up
  end

  # Destroy server and wait for it
  def destroy_and_wait_for_it
    check_ability_to_destroy(name)
    RunnerManagers.digital_ocean.destroy_droplet_by_name(name)
  rescue StandardError => e
    update_column(:_status, :created)
    raise e
  end

  # Check if droplet can be destroyed
  # @param name [String] name of droplet
  # @return [True, False]
  def check_ability_to_destroy(name)
    info = RunnerManagers.digital_ocean.droplet_by_name(name)
    raise "Cannot destroy #{name}, because have no tag #{EXECUTOR_TAG}" unless info.tags.include?(EXECUTOR_TAG)
  end
end
