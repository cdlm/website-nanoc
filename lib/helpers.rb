# -*- encoding : utf-8 -*-
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
