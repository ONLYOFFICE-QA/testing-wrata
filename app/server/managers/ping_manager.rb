module PingManager
  def start_pinging_server
    Thread.new(caller: method(__method__).owner.to_s) do
      loop do
        if @server_model._status == :destroyed
          @status = false
        else
          command = "ping -w1 -c1 #{@server_model.address}"
          r, w = IO.pipe
          pid = spawn(command, out: w)
          Process.wait pid
          w.close
          Rails.logger.info "Executed '#{command}'"
          status = r.read.include?('0 received')
          @status = !status
        end
        sleep TIME_FOR_UPDATE
      end
    end
  end
end
