require 'time'

class PlotData

  def initialize
    plot_data = read_data()
    make_data_file(plot_data)

    text=["Typing speed [words/min]","Work minutes [min]"]
    2.times{|i|
      opts = {:title=>"Elapsed time vs #{text[i]}",
        :plot=>"plot \"./tmp.data\" using 1:#{i+2} w st\n",
        :xlabel=>"Elapsed time[hrs]",:ylabel=>text[i],:xtics=>"0 2"}
      listplot(opts)
    }

    opts = {:title=>"Elapsed time vs Finished steps",
      :xlabel=>"Elapsed time[hrs]",:ylabel=>"Finished steps",:xtics=>"0 2",
      :plot=>"plot \"./tmp.data\" u 1:4 w st ti \"basic drills\", \\
\"./tmp.data\" u 1:5 w st ti \"Gerard Strong drills\""}
    listplot(opts)
  end

  def read_data
    today=Time.now.to_s
    plot_data=[]
    d_total_min=0
    d_step=[[0],[0]]
    File.open(Shunkuntype::TRAIN_FILE,'r'){|file|
      while line=file.gets do
        tmp=line.chomp.split(',')
        d_day = ((Time.parse(tmp[0])-Time.parse(today))/3600/24) #hours
        tmp << "60" if tmp.size ==3 # for backward consist. to "d,f,w"+",t"
        d_speed = tmp[2].to_f/tmp[3].to_f*60
        d_total_min += tmp[3].to_f/60.0  # total_second
        name = tmp[1]
        step = name.scan(/\d+/)[0].to_i # extract step from file name
        name.include?('GerardStrong_data') ? d_step[1] << step : d_step[0] << step
        plot_data << [d_day,d_speed,d_total_min,d_step[0][-1],d_step[1][-1]]
      end
    }
    return plot_data
  end

  def make_data_file(outdata)
    cont=""
    outdata.each {|idata|
      idata.each{|ele| cont << sprintf("%7.2f ",ele)}
      cont << "\n"
    }
    File.open("./tmp.data",'w'){|io| io.print(cont)}
  end

  def listplot(opts)
    cont = ""
    cont << "set xrange \[#{opts[:x]}\]\n" if opts.has_key?(:x)
    cont << "set yrange \[#{opts[:y]}\]\n" if opts.has_key?(:y)
    cont << "set title \"#{opts[:title]}\"\n" if opts.has_key?(:title)
    cont << "set xlabel \"#{opts[:xlabel]}\"\n" if opts.has_key?(:xlabel)
    cont << "set ylabel \"#{opts[:ylabel]}\"\n" if opts.has_key?(:ylabel)
    cont << "set xtics #{opts[:xtics]} \n" if opts.has_key?(:xtics)
    cont << "#{opts[:plot]} \n"
    File.open("./tmp.txt",'w'){|io| io.print(cont)}
    system "gnuplot ./tmp.txt"
  end

end
