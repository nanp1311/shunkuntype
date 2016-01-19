Dir.glob('./*.txt').sort.each do |filename|
  f1=File.basename(filename, '.txt')
  nums=f1.split(/-/)
  text="mv "+filename+" ./STEP-"+nums[1]+".txt\n"
  system text
#  key=nums[0].scan(/\d+/)
#  steps[key] ||=[]
#  steps[key] << nums[1]
end
