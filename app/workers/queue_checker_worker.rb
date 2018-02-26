class QueueCheckerWorker
  def create_thread
    @queue_checker_thread = Thread.new(caller: method(__method__).owner.to_s) do
      loop do
        Rails.application.config.run_manager.check_for_start
        sleep TIME_FOR_UPDATE
      end
    end
  end

  def start_thread
    if @queue_checker_thread.nil?
      create_thread
    elsif @queue_checker_thread.alive?
      @queue_checker_thread.run if @queue_checker_thread.stop?
    end
  end
end
