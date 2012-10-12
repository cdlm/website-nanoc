# -*- encoding : utf-8 -*-
def head_content
  result = ""
  return result unless @item[:head]
  
  @item[:head].each do |elt, elts|
    elts.each do |attrs|
      result << "<#{elt}"
      attrs.each do |k,v|
        result << " #{k}=\"#{v}\""
      end
      result << " />\n"
    end
  end
  result
end
