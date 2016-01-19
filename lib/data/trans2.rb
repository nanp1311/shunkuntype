require 'pp'
data=[]
File.open("data.txt",'r'){|file|
  while word=file.gets do
    data << word.chomp.split(',')
  end
}

data.each do |line|
  nums=line[1].scan(/\d+\./)[0].scan(/\d+/)[0].to_i
  text="data/STEP-"+nums.to_s+".txt"
  print line[0]+","+text+","+line[2]+"\n"
#  key=nums[0].scan(/\d+/)
#  steps[key] ||=[]
#  steps[key] << nums[1]
end
