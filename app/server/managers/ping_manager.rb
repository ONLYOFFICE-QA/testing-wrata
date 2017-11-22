module PingManager
  SSH_PORT = 22
  PING_TIMEOUT = 1

  def start_pinging_server
    Thread.new(caller: method(__method__).owner.to_s) do
      loop do
        @status = if @server_model._status == :destroyed || @server_model.address.nil?
                    false
                  else
                    server_ssh_pinged?(@server_model.address)
                  end
        sleep TIME_FOR_UPDATE
      end
    end
  end

  def server_ssh_pinged?(address)
    command = 'ssh -q -o StrictHostKeyChecking=no'\
              ' -o UserKnownHostsFile=/dev/null '\
              ' -o ConnectTimeout=1 '\
              "#{TestManager::TEST_SPOT_USER_NAME}@#{address} exit"
    system(command)
  end
end
