# -*- encoding : utf-8 -*-

class ClosureCompiler < Nanoc::Filter
  identifier :closure_compiler
  
  def run(content, params={})
    IO.popen("closure --third_party true --warning_level QUIET", 'r+') do |io|
      io.write content
      io.close_write
      io.read
    end
  end

end
