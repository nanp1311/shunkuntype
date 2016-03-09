require 'fileutils'
module Shunkuntype
  VERSION = "1.0.1"
  data_path = File.join(ENV['HOME'], '.shunkuntype')
#  SPEED_FILE="./shunkuntype_speed_data.txt"
  SPEED_FILE=File.join(data_path,"speed_data.txt")
#  TRAIN_FILE="./shunkuntype_training_data.txt"
  TRAIN_FILE=File.join(data_path,"training_data.txt")
  SERVER_FILE=File.join(data_path,"server_data.txt")
end
