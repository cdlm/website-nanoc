# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

require 'nokogiri'

include Nanoc3::Helpers::Blogging
include Nanoc3::Helpers::Capturing
include Nanoc3::Helpers::HTMLEscape
include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::Tagging

# Route by setting the extension
def extension(ext=nil)
  e = ext || item[:extension] || ''
  e = ".#{e}" unless e.empty?
  id = item.identifier.chop
  id = "/index" if id.empty?
  id + e
end

# Attribute lookup
def info(key, item=nil)
  item ||= @item
  item.attributes.fetch(key) { @site.config[:default_info][key] }
end

# Menu generation
def menu_items
  info(:site_menu).collect do |id|
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
  items.find { |i| i.identifier == id }
end

def items_by_identifier(pattern)
  items.select { |i| pattern === i.identifier }
end

# Core extensions
class Nanoc3::Item
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
module Nanoc3::CLI
  class Logger
    (ACTION_COLORS ||= {}).update(
      :create     => "\e[38;5;2m",
      :update     => "\e[38;5;3m",
      :identical  => "\e[1;38;5;6m",
      :skip       => "\e[1;38;5;6m"
    )
  end
end

