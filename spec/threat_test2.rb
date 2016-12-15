
def loop_thread(sec)
  p "hello"
  Thread.start(sec) do |wait_time|
    sleep wait_time
    puts "\a Time up. Type return-key to finish.."
  end
end

def time_training(period)
  loop_thread(period)
  10.times{
    p "helo2"
    p gets
  }
end

time_training(10)
