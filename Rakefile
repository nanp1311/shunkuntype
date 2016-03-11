require "bundler/gem_tasks"
require "rake/testtask"
require 'yard'

#task :default => :test
task :default do
  system 'rake -T'
end


YARD::Rake::YardocTask.new

Rake::TestTask.new(:test) do |test|
  test.libs << "test"
  test.libs << "lib"
  test.test_files = FileList['test/**/*_test.rb']
  test.verbose = true
end

desc "setenv for release from Kwansei gakuin."
task :setenv do
  p command='setenv HTTP_PROXY http://proxy.ksc.kwansei.ac.jp:8080'
  system command
  p command='setenv HTTPS_PROXY http://proxy.ksc.kwansei.ac.jp:8080'
  system command
end
