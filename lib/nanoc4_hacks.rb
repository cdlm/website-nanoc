require 'pry-byebug'

class Nanoc::ItemView

  def nil?
    self.unwrap.nil?
  end

end

class Nanoc::Identifier

  def extension
    File.extname(@string)
  end

end
