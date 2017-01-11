module PingManager
  def start_pinging_server
    Thread.new(caller: method(__method__).owner.to_s) do
      loop do
        if @server_model._status == :destroyed || @server_model.address.nil?
          @status = false
        else
          command = "nc -w 1 -z #{@server_model.address} 22"
          pid = spawn(command)
          Process.wait pid
          @status = ($CHILD_STATUS == 0)
        end
        sleep TIME_FOR_UPDATE
      end
    end
  end
end
