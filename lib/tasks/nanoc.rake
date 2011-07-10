require 'rake'
require 'rake/clean'
CLEAN.include('tmp', '.sass-cache')
CLOBBER.include("#{OUT}/**")

namespace :nanoc do
  
  desc "Compile site using nanoc."
  task :compile do
    system 'nanoc compile'
  end

  desc "Start the nanoc autocompiler."
  task :auto do
    system 'nanoc autocompile --handler thin'
  end

  desc "Serve the website locally."
  task :serve do
    system 'nanoc view --handler thin'
  end
end
