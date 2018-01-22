class ServerDestroyerWorker
  def create_thread
    @server_destroyer_thread = Thread.new(caller: method(__method__).owner.to_s) do
      loop do
        Runner::Application.config.threads.destroy_inactive_servers unless Runner::Application.config.threads.nil?
        sleep TIME_FOR_UPDATE
      end
    end
  end

  def start_thread
    if @server_destroyer_thread.nil?
      create_thread
    elsif @server_destroyer_thread.alive?
      @server_destroyer_thread.run if @server_destroyer_thread.stop?
    end
  end
end
