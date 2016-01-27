require "bundler/gem_tasks"
require "rake/testtask"
require 'yard'

#task :default => :test
task :default do
  system 'rake -T'
end


YARD::Rake::YardocTask.new

desc "hiki upload"
task :hiki do
  dir0="~/Sites/nishitani0/Internal/data/"
  name="TouchTyping_shunkuntype_gemizing"
  system "sudo rm #{dir0}cache/parser/#{name}"
  system "open http://127.0.0.1/~bob/nishitani0/Internal/?#{name}"
  system "open -a mi #{dir0}text/#{name}"
  system "rsync -auvz -e ssh #{dir0} dmz0:#{dir0}"
end

desc "gem upload"
task :upload do
  system "rsync -auvz -e ssh pkg/ dmz0:~/Sites/nishitani0/gems/gems/"
  print "command at dmz0:cd ~/Sites/nishitani0/gems \n"
  print "command at dmz0:gem generate_index \n"
  system "ssh dmz0"
end

Rake::TestTask.new(:test) do |test|
  test.libs << "test"
  test.libs << "lib"
  test.test_files = FileList['test/**/*_test.rb']
  test.verbose = true
end
