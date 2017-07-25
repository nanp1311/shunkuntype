class MkSummary
  def initialize(tmp_dir)
    $mem_dir=File.join(tmp_dir,"mem_data")
    files = Dir::entries($mem_dir)
    member = mk_member(files)
    @scores = take_scores(files,member)
  end

  def mk_member(files)
    member = []
    files.each{|file|
      if file.include?('training') then
        name=file.split('_')[0]
        member << name
      end
    }
    return member
  end

  def take_scores(files,member)
    scores = {}
    member.each{|name|
      p name
      speed_file="#{name}_speed_data.txt"
      if files.include?(speed_file)
        p speed_file
        file = File.readlines(File.join($mem_dir,speed_file))
        init= (file[0]!=nil ? file[0].split(",")[2].to_f : 0.0 )
        cur = (file[-1]!=nil ? file[-1].split(",")[2].to_f : 0.0 )
        scores[name]=[init,cur]
      end
      training_file="#{name}_training_data.txt"
      if files.include?(training_file)
        p training_file
        file = File.readlines(File.join($mem_dir,training_file))
        work_time = file.inject(0){|sum,line|
          sec=line.split(',')[3].to_i
          sec= (sec!=0)? sec : 60
          sum + sec
        }
        step = (file[-1]!=nil ? file[-1].match(/STEP-(\d*)/)[1].to_i : 0 )
        scores[name] << work_time/60 << step
      end
    }
    return scores
  end

  def mk_html_table()
    cont = ""
    title = "Shunkun typer"
    cont << "<table border=\"1\">\n<caption>#{title}<caption>\n"
    cont << "<tr><th></th><th colspan=2>speed[sec]</th><th colspan=2>training</th></tr>\n"
    cont << "<tr><th></th><th>init</th><th>current</th><th>total time[min]</th><th>step</th></tr>\n"
    @scores.each_pair{|key,score|
      cont << "<tr><th>#{key}</th>"
      score.each{|val| cont << sprintf("<td>%5.2f</td>",val)}
      cont << "</tr>\n"
    }
    cont << "</table>\n"
    return cont
  end

  def mk_hiki_table()
    t= Time.now
    cont = "!!Shunkun typer #{t.localtime}\n"
    cont << "|| ||>speed[sec]||>training\n"
    cont << "||||init||current||total time[min]||step\n"
    @scores.each_pair{|key,score|
      cont << "||#{key}"
      score.each{|val| cont << sprintf("||%5.2f",val)}
      cont << "\n"
    }
    cont << "\n"
    return cont
  end
end

