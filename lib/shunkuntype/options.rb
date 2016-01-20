#coding: utf-8

require 'optparse'

module Shunkuntype
  class Command
    module Options

      def self.parse!(argv)
        options = {}
        command_parser = OptionParser.new do |opt|
          opt.on_head('-v', '--version','Show program version') do |v|
            puts options.ver
            opt.version = Shunkuntype::VERSION
            exit
          end
        end

        command_parser.parse!(argv)
      end

    end
  end
end
