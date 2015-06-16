class RspecResult
  attr_accessor :processing, :result, :time, :total, :describe

  def initialize(describe = nil, processing = nil, result = nil, time = nil, total = nil)
    @describe = describe
    @processing = processing
    @result = result
    @time = time
    @total = total
  end
end
