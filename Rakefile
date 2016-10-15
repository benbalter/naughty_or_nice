require 'rake'
require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_naughty_or_nice*.rb'
  test.verbose = true
end

desc 'Open console with Naughty Or Nice loaded'
task :console do
  exec 'pry -r ./lib/naughty_or_nice.rb'
end
