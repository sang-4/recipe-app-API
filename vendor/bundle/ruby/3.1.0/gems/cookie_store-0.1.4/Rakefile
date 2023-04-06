require 'bundler/setup'
require "bundler/gem_tasks"
require 'rake/testtask'
require 'rdoc/task'

task :console do
  exec 'irb -Ilib -r cookie_store.rb'
end
task :c => :console


Rake::TestTask.new do |t|
    t.libs << 'lib' << 'test'
    t.test_files = FileList['test/**/*_test.rb']
    # t.warning = true
    # t.verbose = true
end

desc "Run tests"
task :default => :test
