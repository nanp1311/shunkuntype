# -*- coding: utf-8 -*-
require 'time'
require 'fileutils'
require "gnuplot"

# = gnuplotが扱えるデータフォーマットへの変換
# ==Usage
#    data0 = PlotData.new(name0,0,3,name)
#    data0.add_general_data(name1, 0, 2)
#    start=Time.parse(Time.now.to_s)
#    x_func = proc{|x| ((Time.parse(x)-start)/3600/24) }
#    y_func = proc{|y| y.to_f/60.0 }
#    data0.mk_plot_data(x_func,y_func)
#    data0.sort
#    data0.sum_data
#
class PlotData
  attr_accessor :data, :title

  def initialize(file_name="",x_col=nil,y_col=nil,title="")
    @data=[]
    read_general_data(file_name,x_col,y_col) if ""!=file_name
    @title=title if ""!=title
  end

# @!group data read
  def add_general_data(file, x_col, y_col)
    read_general_data(file, x_col, y_col)
  end

  def read_general_data(file, x_col, y_col)
    File.open(file,'r'){|file|
      while line=file.gets do
        tmp=line.chomp.split(',')
        @data << [tmp[x_col],tmp[y_col]]
      end
    }
  end
# @!endgroup

  #gnuplot libraryに沿った形のdataを出力．
  # 列データを行データに
  def to_gnuplot()
    x,y=[],[]
    @data.each{|ele|
      x << ele[0]
      y << ele[1]
    }
    return [x,y]
  end

  # x_func,y_funcに変換関数をyieldで入れる
  def mk_plot_data(x_func,y_func)
    tmp_data=[]
    @data.each{|ele|
      x_data = x_func.call(ele[0])
      y_data = y_func.call(ele[1])
      tmp_data << [x_data,y_data]
    }
    @data = tmp_data
  end

  #y軸の値の積分を取る
  def sum_data
    tmp_data=[]
    y_data=0
    @data.each{|ele| tmp_data << [ele[0], y_data+=ele[1]]}
    @data = tmp_data
  end

  #x軸の値によってsortをかける．
  def sort
    @data.sort!{|x,y| x[0] <=> y[0]}
  end
end

class MkPlots

  def initialize(tmp_dir,opts={})
    @source_dir=File.join(tmp_dir,'mem_data')
    @mem_names=[]
    @opts = opts
    mk_mem_names()
    work_all()
    FileUtils.mv('res.png', './work.png')
    speed_all()
    FileUtils.mv('res.png', './speed.png')
  end

  def work_all
    all_data= @mem_names.inject([]){|all,name| all << work_view(name) }
    text="Work minutes [min]"
    plot(all_data,text)
    plot(all_data,text,opts={:png=>true})
  end

  def speed_all
    mk_mem_names
    all_data= @mem_names.inject([]){|all,name| all << speed_view(name) }
    text="Typing speed [sec/20 words]"

    plot(all_data,text)
    plot(all_data,text,opts={:png=>true})
  end

  def speed_view(name)
    p name1 = "#{@source_dir}/#{name}_speed_data.txt"
    data0 = PlotData.new(name1, 0, 2, name)
    start=Time.parse(Time.now.to_s)
    x_func = proc{|x| ((Time.parse(x)-start)/3600/24) }
    y_func = proc{|y| y }
    data0.mk_plot_data(x_func,y_func)
    return data0
  end

  def mk_mem_names
    names = Dir.entries(@source_dir)
    names.each{|name|
      title = name.split('_')[0]
      @mem_names << title if (!@mem_names.include?(title) and title.match(/\w/))
    }
  end

  def work_view(name)
    p name0 = "#{@source_dir}/#{name}_training_data.txt"
    p name1 = "#{@source_dir}/#{name}_speed_data.txt"
    data0 = PlotData.new(name0,0,3,name)
    data0.add_general_data(name1, 0, 2)
    start=Time.parse(Time.now.to_s)
    x_func = proc{|x| ((Time.parse(x)-start)/3600/24) }
    y_func = proc{|y| y.to_f/60.0 }
    data0.mk_plot_data(x_func,y_func)
    data0.sort
    data0.sum_data
    return data0
  end

  def plot(data,text0,opts={})
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        plot.title  "Elapsed time vs #{text0}"
        plot.ylabel text0
        plot.xlabel "Elapsed time[days]"
        plot.xtics "0 7"
        if true==opts.has_key?(:png) then
          plot.term "pngcairo enhanced size 480,360"
          plot.output "res.png"
        end

        plot.data = []
        data.each{|ele|
          plot.data << Gnuplot::DataSet.new( ele.to_gnuplot ) do |ds|
            ds.with = "line"
            if ""==ele.title then
              ds.notitle
            else
              ds.title=ele.title
            end
          end
        }
      end
    end
  end
end

if __FILE__ == $0 then
  data0 = PlotData.new()
  data0.read_general_data(ARGV[0], 0, 3)
  data0.add_general_data(ARGV[1], 0, 2)

  start=Time.parse(data0.data[0][0])
  x_func = proc{|x| ((Time.parse(x)-start)/3600/24) }
  y_func = proc{|x| x.to_f/60.0 }
  data0.mk_plot_data(x_func,y_func)
  data0.sort
  data0.sum_data

  text="Work minutes [min]"
  Gnuplot.open do |gp|
    Gnuplot::Plot.new( gp ) do |plot|
      plot.title  "Elapsed time vs #{text}"
      plot.ylabel text
      plot.xlabel "Elapsed time[days]"
      plot.xtics "0 2"
      x,y = data0.to_gnuplot

      plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
        ds.with = "line"
        ds.notitle
      end
    end
  end

end



