class RunnerManagers
  TIME_FOR_SCAN = 15

  attr_accessor :managers

  def initialize
    @managers = []
    Client.all.each do |client|
      @managers << ClientRunnerManager.new(client)
    end
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

  def check_for_start
    @managers.each(&:check_client_for_start)
  end

  class << self
    attr_writer :digital_ocean

    # @return [DigitalOceanWrapper] wrapper for working with DO
    def digital_ocean
      @digital_ocean ||= OnlyofficeDigitaloceanWrapper::DigitalOceanWrapper.new
    end
  end
end

Thread.abort_on_exception = true
