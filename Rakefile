require "bundler/setup"

task default: :test

desc "Run component tests"
task :test do
  sh "bundle exec ruby -Itest -e 'Dir.glob(\"test/components/**/*_test.rb\").sort.each { |f| require File.expand_path(f) }'"
end
