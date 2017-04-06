class Duration

  attr_accessor :time_in_seconds

  def initialize(time_in_seconds)
    @time_in_seconds = time_in_seconds || 0
  end

  def to_s(format = "%H:%M")
    Time.at(@time_in_seconds).utc.strftime("%H:%M")    
  end

  def +(duration)    
    @time_in_seconds += duration.time_in_seconds
    self
  end
end