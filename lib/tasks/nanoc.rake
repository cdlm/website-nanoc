require 'rake'
require 'rake/clean'
CLEAN.include("#{OUT}/**", 'tmp', 'nanoc-autocompile.log')

desc "Compile site using nanoc."
task :compile do
  system 'nanoc compile'
end

desc "Start the nanoc autocompiler."
task :auto do
  system 'nanoc autocompile --handler thin > nanoc-autocompile.log 2>&1'
end
