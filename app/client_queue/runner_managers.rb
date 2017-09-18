class RunnerManagers
  attr_accessor :managers

  def initialize(managers = [])
    @managers = managers
  end

  def add_manager(manager)
    @managers << manager
  end

  def find_manager_by_client_login(client_login)
    manager = nil
    unless @managers.empty?
      @managers.each do |cur_manager|
        if cur_manager.client.login == client_login
          manager = cur_manager
          break
        end
      end
    end
    manager
  end

  # @param server_name [String] remove server from managers
  # @return [Nothing]
  def remove_server(server_name)
    @managers.each do |current_manager|
      current_manager.delete_server(server_name)
    end
  end

  class << self
    attr_writer :digital_ocean

    # @return [DigitalOceanWrapper] wrapper for working with DO
    def digital_ocean
      @digital_ocean ||= OnlyofficeDigitaloceanWrapper::DigitalOceanWrapper.new
    end

    # Check if runner logs folder are mounted. Without it - no working.
    def ensure_logs_folder_present
      return if Rails.env.test?
      return if Dir.exist?(HTMLResultManager::RSPEC_HTML_LOGS_FOLDER)
      raise "No runner logs folder present: #{HTMLResultManager::RSPEC_HTML_LOGS_FOLDER}. Mount it"
    end
  end
end

Thread.abort_on_exception = true
