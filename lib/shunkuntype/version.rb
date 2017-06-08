require 'fileutils'
require 'tmpdir'

module Shunkuntype
  VERSION = "1.0.11"
  data_dir = File.join(ENV['HOME'], '.shunkuntype')
#  SPEED_FILE="./shunkuntype_speed_data.txt"
  SPEED_FILE=File.join(data_dir,"speed_data.txt")
#  TRAIN_FILE="./shunkuntype_training_data.txt"
  TRAIN_FILE=File.join(data_dir,"training_data.txt")
  SERVER_FILE=File.join(data_dir,"server_data.txt")
end
