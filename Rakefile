require "bundler/gem_tasks"
require "rake/testtask"
require 'yard'
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default do
  system 'rake -T'
end

desc "make documents by yard"
task :yard do
  system "hiki2md docs/readme.en.hiki > docs/README.en.md"
  system "hiki2md docs/readme.ja.hiki > docs/README.ja.md"
  YARD::Rake::YardocTask.new
end

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
