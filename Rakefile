require "bundler/gem_tasks"
require "rake/testtask"
# require 'yard'
require "rspec/core/rake_task"
p base_path = File.expand_path('..', __FILE__)
p basename = File.basename(base_path)

RSpec::Core::RakeTask.new(:spec)

task :default do
  system 'rake -T'
end

desc "make documents by yard"
task :yard do
  files = Dir.entries('docs')
  files.each{|file|
    name=file.split('.')
    if name[1]=='hiki' then
      p command="hiki2md docs/#{name[0]}.hiki > shunkuntype.wiki/#{name[0]}.md"
      system command
    end
  }
  p command="cp shunkuntype.wiki/readme_en.md ./README.md"
  p command="cp shunkuntype.wiki/readme_ja.md shunkuntype.wiki/Home.md"
  system command
  system "cp docs/*.gif #{basename}.wiki/img"
  system "cp docs/*.gif doc"
  system "cp docs/*.png #{basename}.wiki/img"
  system "cp docs/*.png doc"
  system "cp docs/*.pdf #{basename}.wiki"
  system "cp docs/*.pdf doc"
  YARD::Rake::YardocTask.new
end

Rake::TestTask.new(:test) do |test|
  test.libs << "test"
  test.libs << "lib"
  test.test_files = FileList['test/**/*_test.rb']
  test.verbose = true
end


