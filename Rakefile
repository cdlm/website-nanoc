require 'nanoc3/tasks'
OUT = Nanoc3::Site.new('.').config[:output_dir]
Dir['lib/tasks/**/*.rake'].each { |f| Rake.application.add_import(f) }

task :default => [:'nanoc:compile']
