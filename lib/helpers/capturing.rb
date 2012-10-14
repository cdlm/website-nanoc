# -*- encoding : utf-8 -*-
module Capturing

  include Nanoc::Helpers::Capturing

  def excerpt(name, &block)
    content_for name, &block
    buffer = eval '_erbout', block.binding
    buffer << content_for(@item, name)
  end

end

include Capturing
