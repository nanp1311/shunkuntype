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
  p command="hiki2md docs/readme.en.hiki > docs/README.en.md"
  system command
  p command="hiki2md docs/readme.ja.hiki > docs/README.ja.md"
  system command
  p command="mv docs/README.en.md ./README.md"
  system command
  YARD::Rake::YardocTask.new
end

Rake::TestTask.new(:test) do |test|
  test.libs << "test"
  test.libs << "lib"
  test.test_files = FileList['test/**/*_test.rb']
  test.verbose = true
end


