require "shunkuntype/version"
require "shunkuntype/speed"
require "shunkuntype/training"
require "shunkuntype/options"

module Shunkuntype
  # Your code goes here...
  class Command

    def self.run(argv=[])
      print "Hello world.\n"
#      SpeedCheck.new
#      Training.new
      new(argv).execute
    end

    def initialize(argv=[])
      @argv = argv
    end

    def execute
      return if @argv.size==0
      command_parser = OptionParser.new do |opt|
        opt.on('-v', '--version','Show program version.') do |v|
          opt.version = Shunkuntype::VERSION
          puts opt.ver
          exit
        end
        opt.on('-s', '--speed','Speed check.') do |v|
          SpeedCheck.new
          exit
        end
      end

      command_parser.parse!(@argv)
#
#
#      sub_command = options.delete(:command)
#
#      begin
#        tasks = case sub_command
#                when 'version'
#                when 'delete'
#                  delete_task(options[:id])
#                when 'update'
#                  update_task(options[:id], options)
#                when 'list'
#                  find_tasks(options[:status])
#                end
#        display_tasks tasks
#      rescue => e
#        abort "Error: #{e.message}"
#      end

    end
  end
end
