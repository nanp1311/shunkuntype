require 'optparse'
require "shunkuntype/version"
require "shunkuntype/speed"
require "shunkuntype/training"
require "shunkuntype/finished_check"
require "shunkuntype/plot"
require "shunkuntype/mk_summary"
require "shunkuntype/plot_data"
require "shunkuntype/db"
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
      DataFiles.prepare

      @argv << '--help' if @argv.size==0
      command_parser = OptionParser.new do |opt|
        opt.on('-v', '--version','show program Version.') { |v|
          opt.version = Shunkuntype::VERSION
          puts opt.ver
        }
        opt.on('-c', '--check','Check speed') {|v| SpeedCheck.new }
        opt.on('-d', '--drill [VAL]','one minute Drill [VAL]', Integer) {|v| Training.new(v) }
        opt.on('-h', '--history','view training History') {|v| FinishCheck.new }
        opt.on('-p', '--plot','Plot personal data') { |v| PlotPersonalData.new }
        opt.on('-s', '--submit','Submit data to dmz0') { |v| report_submit()}
        opt.on('--reset','reset training data') { |v| reset_data()}
        opt.on('--review [FILE]','Review training, TAGs=html or hiki'){|v| data_viewing(v)}
      end
      command_parser.parse!(@argv)
      exit
    end

    def reset_data
      data_dir = File.join(ENV['HOME'], '.shunkuntype')
      FileUtils.cd(data_dir)
      begin
        FileUtils.mkdir('old_data',:verbose => true)
      rescue Errno::EEXIST
        print "Directory 'old_data' exists at #{data_dir}.\n\n"
      end
      time=Time.now.strftime("%Y%m%d%H%M%S")
      ['speed_data','training_data'].each{|file|
        target = File.join(data_dir,'old_data',"#{file}_#{time}.txt")
        FileUtils.mv(file+'.txt',target,:verbose=>true)
      }
    end

    def report_submit
      server_info=File.readlines(Shunkuntype::SERVER_FILE)
      p server_directory=server_info[0].chomp
      p user_name=server_info[0].split('@')[0]
      system "scp #{Shunkuntype::TRAIN_FILE} #{server_directory}/#{user_name}_training_data.txt"
      system "scp #{Shunkuntype::SPEED_FILE} #{server_directory}/#{user_name}_speed_data.txt"
    end

    def data_viewing(file)
      # opts for MkPlots could be described in file 
      # Not coded yet at all!!!
      if file==nil then
        opts = {}
      end
      server_info=File.readlines(Shunkuntype::SERVER_FILE)
      p server_directory=server_info[0].chomp
      Dir.mktmpdir('shunkun'){|tmp_dir|
        p tmp_dir
        FileUtils.mkdir_p(File.join(tmp_dir,'mem_data'))
        system "scp -r #{server_directory}/* #{tmp_dir}/mem_data"
        # write data to file
        table = MkSummary.new(tmp_dir)
        MkPlots.new(tmp_dir,opts)
        File.open('./tmp.html','a'){|f|
          f.write("<html>\n")
          f.write(table.mk_html_table())
          f.write("<p><img src=\"./work.png\" /></p>")
          f.write("<p><img src=\"./speed.png\" /></p>")
          f.write("</html>\n")
        }
        File.open('./tmp.hiki','a'){|f|
          f.write(table.mk_hiki_table())
          f.write('||{{attach_view(work.png)}}')
          f.write('||{{attach_view(speed.png)}}')
          f.write("\n")
        }
      }
    end
  end
end
