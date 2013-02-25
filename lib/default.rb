# -*- encoding : utf-8 -*-
# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

require 'nokogiri'

include Nanoc::Helpers::Blogging
include Nanoc::Helpers::Capturing
include Nanoc::Helpers::HTMLEscape
include Nanoc::Helpers::LinkTo
include Nanoc::Helpers::Rendering
include Nanoc::Helpers::Tagging

# Route by setting the extension
def extension(ext=nil, opts={})
  e = ext || item[:extension] || ''
  e = ".#{e}" unless e.empty?
  id = item.identifier.chop
  id += "/index" if opts[:as_index] || id.empty?
  id + e
end

# Attribute lookup
def info(key, item=nil)
  item ||= @item
  item.attributes.fetch(key) do
    if item.parent.nil?
      @site.config[:default_info].fetch(key){ @site.config[key] }
    else
      info key, item.parent
    end
  end
end

# Menu generation
def menu_items
  info(:header_menu).collect do |id|
    item_named(id)
  end
end

def menu_link(item)
  title = item[:menu_title] || item[:title]
  ancestor_link_unless_current title, item
end

def ancestor_link_unless_current(title, destination)
  attributes = {}
  if not destination.is_root? and destination.ancestor_of? @item
    attributes.update :class => 'active'
  end
  if destination != @item
    attributes.update :href => (relative_path_to destination)
    elt = 'a'
  else
    attributes.update :title => "You're here"
    elt = 'span'
  end
  result = "<#{elt}"
  attributes.each do |k,v|
    result << " #{k}=\"#{html_escape v}\""
  end
  result << ">#{title}</#{elt}>"
end

def item_named(id)
  items[id] # since nanoc 3.6.0
end

def items_by_identifier(pattern)
  items.select { |i| pattern === i.identifier }
end

# Core extensions
class Nanoc::Item
  # Item hierarchy
  def ancestor_of?(item)
    return false if item.nil?
    return true if item == self
    return true if item.parent == self
    return true if self.children.include?(item)
    ancestor_of?(item.parent)
  end
  def is_root?()  self.identifier == '/'  end
end

# Patch colors for solarized shinyness
module Nanoc::CLI
  class Logger
    (ACTION_COLORS ||= {}).update(
      :create     => "\e[38;5;2m",
      :update     => "\e[38;5;3m",
      :identical  => "\e[1;38;5;6m",
      :skip       => "\e[1;38;5;6m"
    )
  end
end

