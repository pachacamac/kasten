require "bundler/gem_tasks"

task :default => :spec
require "rake/extensiontask"

task :build => :compile

Rake::ExtensionTask.new("kasten") do |ext|
  ext.lib_dir = "lib/kasten"
end
