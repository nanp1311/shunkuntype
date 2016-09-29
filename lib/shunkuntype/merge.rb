require 'time'

def data_merge(file_current, file_server)
  all_data=[]
  i,j=0,0
  while (file_current.length > i) and (file_server.length > j) do
    line_current,line_server = file_current[i], file_server[j]
    break if line_current=="\n" or line_server=="\n"
    time_current=Time.parse(line_current.split(',')[0])
    time_server=Time.parse(line_server.split(',')[0])
    if time_current == time_server then
      all_data << line_current
      i += 1
      j += 1
    elsif time_current < time_server then
      all_data << line_current
      i += 1
    else
      all_data << line_server
      j += 1
    end
  end
  while (file_current.length > i)
    all_data << file_current[i]
    i += 1
  end
  while (file_server.length > j)
    all_data <<  file_server[j]
    j += 1
  end
  all_data.delete("\n")
  return all_data.join
end

if $0 == __FILE__ then
  file_current = <<'EOS'
2016-09-23 13:41:36 +0900,STEP-1.txt,60,60
2016-09-23 13:48:45 +0900,STEP-2.txt,5,60
2016-09-28 11:41:56 +0900,STEP-2.txt,0,60
2016-09-28 11:51:46 +0900,STEP-15.txt,29,60
2016-09-28 12:47:48 +0900,STEP-3.txt,48,60
2016-09-28 12:50:12 +0900,STEP-1.txt,60,60

EOS
  file_server = <<'EOS'
2016-09-23 13:41:36 +0900,STEP-1.txt,60,60
2016-09-23 13:48:45 +0900,STEP-2.txt,5,60
2016-09-28 12:48:57 +0900,STEP-4.txt,50,60

EOS
  print data_merge(file_current.lines, file_server.lines)
end
