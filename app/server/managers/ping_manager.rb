module PingManager

  def start_pinging_server
    Thread.new do
      @digital_ocean = DigitalOceanWrapper.new
      while true
        if @digital_ocean.get_droplet_by_name @server_model.name
          command = "ping -w1 -c1 #{@server_model.address}"
          r, w = IO.pipe
          pid = spawn(command, :out => w)
          Process.wait pid
          w.close
          status = r.read.include?('0 received')
          @status = !status
        else
          @status = false
        end
        sleep TIME_FOR_UPDATE
      end
    end
  end

end