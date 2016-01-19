require "shunkuntype/version"
require "shunkuntype/speed"
require "shunkuntype/training"

module Shunkuntype
  # Your code goes here...
  class Command

    def self.run(argv=[])
      print "Hello world.\n"
#      SpeedCheck.new
      Training.new
#      new(argv).execute
    end

    def initialize(argv=[])
      @argv = argv
    end

    def execute
      options = Options.parse!(@argv) if @argv.size!=0
      sub_command = options.delete(:command)

      begin
        tasks = case sub_command
                when 'create'
                  create_task(options[:name], options[:content])
                when 'delete'
                  delete_task(options[:id])
                when 'update'
                  update_task(options[:id], options)
                when 'list'
                  find_tasks(options[:status])
                end
        display_tasks tasks
      rescue => e
        abort "Error: #{e.message}"
      end

    end
  end
end
