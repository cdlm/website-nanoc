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
def info(key)
  item.attributes.fetch(key) { config[:default_info][key] }
end

# Menu generation
def menu_items
  info(:site_menu).collect do |each|
    items.find { |any| any.identifier == each }
  end
end

def menu_link(item)
  title = item[:menu_title] || item[:title]
  ancestor_link_unless_current title, item
end

def ancestor_link_unless_current(title, item)
  destination = item.as_item
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

# Core extensions
class Nanoc3::Item
  class << self
    def by_identifier(id)  @items.find { |i| i.identifier == id }  end
    def by_path(p) # probable bug: reps have paths, not items 
      @items.find { |i| i.path == p }  end
  end
  def as_item()  return self  end
  def ancestor_of?(item)
    return false if item.nil?
    return true if item == self
    return true if item.parent == self
    return true if self.children.include?(item)
    ancestor_of?(item.parent)
  end
  def is_root?()  self.identifier == '/'  end
end
class String
  def as_item()  return Nanoc3::Item.by_identifier self  end
end

# patch colors for solarized shinyness
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

