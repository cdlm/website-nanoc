require 'pry-byebug'

class Nanoc::ItemView

  def nil?
    self.unwrap.nil?
  end

end
