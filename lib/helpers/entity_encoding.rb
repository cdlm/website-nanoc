# -*- encoding : utf-8 -*-

# Shamelessly copied from Nanoc's HTMLEscape
module EntityEncoding

  require 'uri'
  require 'nanoc/helpers/capturing'
  require 'nanoc/helpers/html_escape'
  include Nanoc::Helpers::Capturing
  include Nanoc::Helpers::HTMLEscape

  # Encode the given string or block. All characters are replaced by
  # their numeric HTML entities.
  def entity_encode(string=nil, &block)
    if block_given?
      data = capture(&block)
      encoded = entity_encode(data)

      buffer = eval('_erbout', block.binding)
      buffer << encoded
    elsif string
      encoded = ""
      string.each_char { |c| encoded << "&##{c[0].ord};" }
      return encoded
    else
      raise RuntimeError, "The #entity_encode function needs either a " \
        "string or a block to encode, but neither was given"
    end
  end

  # Generate a `<mailto>` tag with the address encoded as HTML numeric entities.
  def mailto(email, subject=nil, text=nil, attributes = {})
    email = entity_encode(email)
    
    subject &&= '?subject=' + URI.escape(subject)

    text &&= html_escape(text)
    text ||= email

    # Join attributes
    attributes = attributes.inject('') do |memo, (key, value)|
      "#{memo} #{key.to_s}='#{h(value)}'"
    end

    # Create link
    "<a href='mailto:#{email}#{subject}'#{attributes}>#{text}</a>"
  end

end

include EntityEncoding

