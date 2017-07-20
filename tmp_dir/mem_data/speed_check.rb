require 'systemu'

Dir.glob('./*speed_data*').each{|file|
  status, stdout, stderr = systemu "tail -1 #{file}"
  printf("%s %4.2f\n",file[0..7],stdout.split(',')[2].to_f)
}
