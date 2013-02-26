# -*- encoding : utf-8 -*-

class External < Nanoc::Filter
  identifier :external
  
  def run(content, params={})
    raise ArgumentError, "External filter requires a :cmd argument" if params[:cmd].nil?
    IO.popen(params[:cmd], 'r+') do |io|
      if params.fetch(:pipe_content, true)
        io.write content
        io.close_write
      end
      io.read
    end
  end

end
