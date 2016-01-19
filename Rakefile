require "bundler/gem_tasks"
require "rake/testtask"
require 'yard'

#task :default => :test
task :default do
  system 'rake -T'
end


YARD::Rake::YardocTask.new

task :hiki do
  dir0="~/Sites/nishitani0/Internal/data"
  name="TouchTyping_shunkuntype_gemizing"
  system "sudo rm #{dir0}/cache/parser/#{name}"
  system "open http://127.0.0.1/~bob/nishitani0/Internal/?#{name}"
  system "open -a mi #{dir0}/text/#{name}"
end

Rake::TestTask.new(:test) do |test|
  test.libs << "test"
  test.libs << "lib"
  test.test_files = FileList['test/**/*_test.rb']
  test.verbose = true
end
