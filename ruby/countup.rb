class Counter

  def initialize
    @count = 0
  end

  def countup
    @count += 1
    print @count
  end

end

counter = Counter.new
counter.countup
counter.countup
counter.countup
