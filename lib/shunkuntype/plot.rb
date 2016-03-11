require 'time'
require 'tempfile'

class PlotPersonalData
  def initialize
    plot_data = read_data()
    make_data_file(plot_data)

    text=["Typing speed [words/min]","Work minutes [min]"]
    opts = {:title=>"Elapsed time vs #{text[0]}",
      :plot=>"plot \"#{$temp.path}\"  using 1:2 w st\n",
      :xlabel=>"Elapsed time[hrs]",:ylabel=>text[0],:xtics=>"0 2"}
    listplot(opts)
    opts = {:title=>"Elapsed time vs #{text[1]}",
      :plot=>"plot \"#{$temp.path}\" using 1:3 w st\n",
      :xlabel=>"Elapsed time[hrs]",:ylabel=>text[1],:xtics=>"0 2"}
    listplot(opts)
  end

  def read_data
    today=Time.now.to_s
    plot_data=[]
    d_total_min=0
    File.open(Shunkuntype::TRAIN_FILE,'r'){|file|
      while line=file.gets do
        tmp=line.chomp.split(',')
        d_day = ((Time.parse(tmp[0])-Time.parse(today))/3600/24) #hours
        tmp << "60" if tmp.size ==3 # for backward consist. to "d,f,w"+",t"
        d_speed = tmp[2].to_f/tmp[3].to_f*60
        d_total_min += tmp[3].to_f/60.0  # total_second
        name = tmp[1]
        step = name.scan(/\d+/)[0].to_i # extract step from file name
        plot_data << [d_day,d_speed,d_total_min]
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
    $temp=Tempfile.new(["tmp",".data"])
    $temp.puts(cont)
    $temp.close # must! before another use
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
    temp2= Tempfile.new(["tmp",".txt"])
    temp2.print(cont)
    temp2.close # must! before another use
    p command ="gnuplot #{temp2.path}"
    system command
  end

end
