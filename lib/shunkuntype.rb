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
        opt.on('-v', '--version','show program Version.') { |v|
          opt.version = Shunkuntype::VERSION
          puts opt.ver
        }
        opt.on('-i', '--init','Initialize data files') {|v| InitDataFiles.new }
        opt.on('-c', '--check','Check speed') {|v| SpeedCheck.new }
        opt.on('-t', '--training [VAL]','one minute Training of file [VAL]', Integer) {|v| Training.new(v) }
        opt.on('-h', '--history','view training History') {|v| FinishCheck.new }
        opt.on('-p', '--plot','Plot personal data') { |v| PlotPersonalData.new }
        opt.on('-s', '--submit','Submit data to dmz0') { |v| report_submit()}
        opt.on('--review [VALUE]',[:html,:hiki],'Review training, VALUEs=html or hiki'){|v| data_viewing(v)}
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

    def data_viewing(form)
      system "scp -r dmz0:/Users/bob/Sites/nishitani0/ShunkunTyper/mem_data ."
      # write data to file
      table = MkSummary.new
      MkPlots.new
      p form ||= :html
      case form
        when :html then
        File.open('tmp.html','a'){|f|
          f.write("<html>\n")
          f.write(table.mk_html_table())
          f.write("<p><img src=\"./work.png\" /></p>")
          f.write("<p><img src=\"./speed.png\" /></p>")
          f.write("</html>\n")
        }
        when :hiki then
        File.open('tmp.hiki','a'){|f|
          f.write(table.mk_hiki_table())
          f.write('||{{attach_view(work.png)}}')
          f.write('||{{attach_view(speed.png)}}')
          f.write("\n")
        }
        else
        exit
      end
    end
  end
end
