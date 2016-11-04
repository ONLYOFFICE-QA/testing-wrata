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

  class << self
    attr_accessor :digital_ocean

    # @return [DigitalOceanWrapper] wrapper for working with DO
    def digital_ocean
      @digital_ocean ||= OnlyofficeDigitaloceanWrapper::DigitalOceanWrapper.new
    end
  end
end

Thread.abort_on_exception = true
