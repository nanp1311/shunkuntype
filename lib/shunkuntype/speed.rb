
class SpeedCheck
  attr_reader :number, :period

  # print key positions
  def print_keyboard
    content = <<-EOF
 q \\ w \\ e \\ r t \\ y u \\ i \\ o \\ p
  a \\ s \\ d \\ f g \\ h j \\ k \\ l \\ ; enter
sh z \\ x \\ c \\ v b \\ n m \\ , \\\ . \\  shift
EOF
    print content
  end

  def initialize
    @number = 20 #default 20
    @period = 60
    check_data_files
    data = mk_random_words
    t0,t1,count = exec_speed_check(data)
    keep_record(t0,t1,count)
  end

  def check_data_files
    begin
      file=open(Shunkuntype::SPEED_FILE,"r")
      if file
        puts "#{Shunkuntype::SPEED_FILE} opened succcessfully"
      end
    rescue
      puts "#{Shunkuntype::SPEED_FILE} does not exist in this directory. --init or try in another dir."
      exit
    end
  end
  def mk_random_words
    data=[]
    data_dir=File.expand_path('../../../lib/data', __FILE__)
    #    file=open("#{data_dir}/word.list",'r')
    file=open("#{data_dir}/nakata.list",'r')
    File.readlines(file).each do |line|
      #      data << word.chomp
      #            data << line.scan(/(.+)\s+/)[0]
      p line.match(/(.+)\s/)
    end
    exit
    data.shuffle!
    data.each do |word|
      print word+" "
    end
    return data
  end

  def exec_speed_check(data)
    print "\n\n"+number.to_s+" words should be cleared."
    print "\nType return-key to start."
    p ''
    line=$stdin.gets

    t0=Time.now
    count=0
    @number.times do |i|
      print_keyboard()
      puts (i+1).to_s
      word = data[i]
      count+=word.length
      while line!=word do
        puts word
        p ''
        line=$stdin.gets.chomp
      end
    end
    t1=Time.now
    return t0,t1,count
  end

  def keep_record(t0,t1,count)
    statement = t0.to_s+","
    statement << @number.to_s+","
    statement << (t1-t0).to_s+","
    icount=@period/(t1-t0)*count
    statement << icount.to_s+"\n"
    data_file=open(Shunkuntype::SPEED_FILE,"a+")
    data_file << statement
    p statement

    printf("%5.3f sec\n",Time.now-t0)
    printf("%4d characters.\n",icount)
  end
end
