# -*- encoding : utf-8 -*-

def img(item=nil, attributes={})
  # see Nanoc::Helpers::LinkTo#link_to
  if item.nil?
    raise Nanoc::Errors::GenericTrivial.new "No src specified for img" unless attributes.has_key? :src
  else
    item = item_named(item) if item.is_a? String
    path = item.path
    raise Nanoc::Errors::GenericTrivial.new "Cannot insert #{item.inspect} as an image because this item is not outputted (its routing rule returns nil)" if path.nil?
    attributes[:src] = path
  end

  attributes = attributes.inject('') do |memo, (key, value)|
    memo + key.to_s + '="' + h(value) + '" '
  end

  "<img #{attributes}/>"
end

def clear
  '<div class="clear">&nbsp;</div>'
end

def phone(main, opts={})
  prefix = opts.fetch :prefix, 33
  separator = opts[:separator] || '&nbsp;'

  parts = main.scan /\d+/
  unless prefix.nil?
    parts[0].sub!(/\d/) { |digit| "(#{digit})" }
    parts.unshift "+#{prefix}"
  end
  parts.join separator
end
