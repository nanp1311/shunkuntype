require 'optparse'
require "shunkuntype/version"
require "shunkuntype/speed"
require "shunkuntype/training"
require "shunkuntype/init"
require "shunkuntype/finished_check"
require "shunkuntype/plot"
require "shunkuntype/mk_summary"
require "shunkuntype/plot_data"
require 'systemu'

module Shunkuntype
  class Command

    def self.run(argv=[])
      print "Shunkuntype says 'Hello world'.\n"
      new(argv).execute
    end

    def initialize(argv=[])
      @argv = argv
    end

    def execute
      @argv << '--help' if @argv.size==0
      command_parser = OptionParser.new do |opt|
        opt.on('-v', '--version','Show program version.') { |v|
          opt.version = Shunkuntype::VERSION
          puts opt.ver
        }
        opt.on('-i', '--init','initialize data files.') {|v| InitDataFiles.new }
        opt.on('-s', '--speed','speed check.') {|v| SpeedCheck.new }
        opt.on('-m', '--minute [VAL]','minute training of file Integer.', Integer) {|v| Training.new(v) }
        opt.on('-h', '--history','view training history.') {|v| FinishCheck.new }
        opt.on('-p', '--plot','plot data view') { |v| PlotData.new }
        opt.on('-r', '--report','submit data to dmz0') { |v| report_submit()}
        opt.on('-d', '--data','data viewing for all members') { |v| data_viewing()}
      end
      command_parser.parse!(@argv)
      exit
    end

    def report_submit
          status, stdout, stderr = systemu "users"
          p name = stdout.chomp
          trans = {"MorishitaShinya"=>'donkey',"iwasakyouyuu"=>'iwasa','FujimotoKouki'=>'fujimoto',
            "kiyoharamotoyuki"=>'kiyohara',"sumitashinya"=>'sumita'}
          true_name = trans.include?(name) ? trans[name] : name
          p true_name
          dir ='/Users/bob/Sites/nishitani0/ShunkunTyper/mem_data'
          system "scp #{Shunkuntype::TRAIN_FILE} #{true_name}@dmz0:#{dir}/#{true_name}_training_data.txt"
          system "scp #{Shunkuntype::SPEED_FILE} #{true_name}@dmz0:#{dir}/#{true_name}_speed_data.txt"
    end

    def data_viewing
      # download data
      system "scp -r dmz0:/Users/bob/Sites/nishitani0/ShunkunTyper/mem_data ."
      # write data to file
      table = MkSummary.new
      MkPlots.new
      File.open('tmp.html','a'){|f|
        f.write("<html>\n")
        f.write(table.mk_html_table())
        f.write("<p><img src=\"./work.png\" /></p>")
        f.write("<p><img src=\"./speed.png\" /></p>")
        f.write("</html>\n")
      }
    end
  end
end
