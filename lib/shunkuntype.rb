require "shunkuntype/version"
require "shunkuntype/speed"
require "shunkuntype/training"
require "shunkuntype/init"

module Shunkuntype
  # Your code goes here...
  class Command

    def self.run(argv=[])
      print "Shunkuntype says 'Hello world'.\n"
      new(argv).execute
    end

    def initialize(argv=[])
      @argv = argv
    end

    def execute
      return if @argv.size==0
      command_parser = OptionParser.new do |opt|
        opt.on('-v', '--version','Show program version.') { |v|
          opt.version = Shunkuntype::VERSION
          puts opt.ver
        }
        opt.on('-i', '--init','Initialize data files.') {|v| InitDataFiles.new }
        opt.on('-s', '--speed','Speed check.') {|v| SpeedCheck.new }
        opt.on('-m', '--minute VAL','Minute training of file Integer.', Integer) {|v| Training.new(v) }
      end
      command_parser.parse!(@argv)
      exit
    end
  end
end
