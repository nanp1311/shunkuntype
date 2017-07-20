require 'optparse'
require "shunkuntype/version"
require "shunkuntype/speed"
require "shunkuntype/training"
require "shunkuntype/finished_check"
require "shunkuntype/plot"
require "shunkuntype/mk_summary"
require "shunkuntype/plot_data"
require "shunkuntype/db"
require "shunkuntype/merge"
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
      p 'report submission'
      p data_dir = File.join(ENV['HOME'], '.shunkuntype')
      FileUtils.cd(data_dir)
      unless File.exists?(Shunkuntype::SERVER_FILE)
        print "Input server_directory?:"
        p tmp = gets
        File.open(Shunkuntype::SERVER_FILE,'w'){|f| f.print(tmp) }
      end
      server_info=File.readlines(Shunkuntype::SERVER_FILE)
      p @server_directory=server_info[0].chomp
      p @user_name=server_info[0].split('@')[0]
      ['training_data.txt','speed_data.txt'].each{|ext|
        file_merge(ext)
        system "scp tmp_data.txt #{ext}"
      }
    end

    def file_merge(ext_name)
      file_name=ext_name
      file_current = File.readlines(file_name)
      tmp_file = File.open("./tmp_data.txt",'w')
      sta, out, stderror = systemu "scp #{@server_directory}/#{@user_name}_#{ext_name} ."
      p stderror
      unless stderror.include?(" No such file or directory") then
        file_server = File.readlines("#{@user_name}_#{ext_name}")
        tmp_file.print data_merge(file_current,file_server)
      else
        p " No such file or directory in server.\n"
        tmp_file.print file_current.join
      end
      tmp_file.close
      system "cat tmp_data.txt"
      system "scp tmp_data.txt #{@server_directory}/#{@user_name}_#{ext_name}"
    end

    def data_viewing(file)
      # opts for MkPlots could be described in file
      # Not coded yet at all!!!
      if file==nil then
        opts = {}
      end
      server_info=File.readlines(Shunkuntype::SERVER_FILE)
      p server_directory=server_info[0].chomp
#      Dir.mktmpdir('shunkun'){|tmp_dir|
      ['tmp_dir'].each{|tmp_dir|
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
