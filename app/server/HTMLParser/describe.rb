class Describe

  attr_accessor :child, :text

  def initialize(text, child = [], result = nil)
    @text = text
    @child = child
    @result = result
  end

  def find_last_on_lvl(level)
    level == 0 ? self : @child.last.find_last_on_lvl(level - 1)
  end

end
