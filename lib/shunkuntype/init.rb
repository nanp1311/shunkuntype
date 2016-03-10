class InitDataFiles
  def initialize
    if File::exist?("./speed_data.txt") then
      system "mv ./speed_data.txt #{Shunkuntype::SPEED_FILE}"
      print "moving ./speed_data.txt #{Shunkuntype::SPEED_FILE}.\n"
    end
    if File::exist?("./training_data.txt") then
      system "mv ./training_data.txt #{Shunkuntype::TRAIN_FILE}"
      print "moving ./training_data.txt #{Shunkuntype::TRAIN_FILE}.\n"
    end
    if File::exist?(Shunkuntype::SPEED_FILE) then
      print "#{Shunkuntype::SPEED_FILE} exits.\n"
    else
      File::open(Shunkuntype::SPEED_FILE,'a')
      print "make #{Shunkuntype::SPEED_FILE}\n"
    end
    if File::exist?(Shunkuntype::TRAIN_FILE) then
      print "#{Shunkuntype::TRAIN_FILE} exits.\n"
    else
      File::open(Shunkuntype::TRAIN_FILE,'a')
      print "make #{Shunkuntype::TRAIN_FILE}\n"
    end
  end
end
