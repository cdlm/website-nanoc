# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

require 'nokogiri'
# require 'html5small/nanoc'

include Nanoc::Helpers::Blogging
include Nanoc::Helpers::Capturing
include Nanoc::Helpers::ChildParent
include Nanoc::Helpers::HTMLEscape
include Nanoc::Helpers::LinkTo
include Nanoc::Helpers::Rendering
include Nanoc::Helpers::Tagging


# Route by setting the extension
def extension(ext=nil, opts={})
  e = ext || item.identifier.ext || ''
  i = item.identifier.without_ext
  i = i.sub(/(\/index)?\z/, '/index') if opts[:as_index]
  i += ".#{e}" unless e.empty?
  i
end

# Menu generation
def menu_items
  binding.pry if /citezen/ === item.identifier
  info(:header_menu).collect do |id|
    item = item_named(id)
    binding.pry if item.nil?
    item
  end
end

def menu_link(item)
  title = item[:menu_title] || item[:title]
  ancestor_link_unless_current title, item
end

def ancestor_link_unless_current(title, destination)
  attributes = {}
  # binding.pry
  if not root?(destination) and ancestors?(destination, @item)
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
  @items[id] # since nanoc 3.6.0
end

def items_by_identifier(pattern)
  items.select { |i| pattern === i.identifier }
end

# Item hierarchy
def ancestors?(possible_ancestor, item)
  parent = hierarchy(item).parent
  return false if item.nil? || parent.nil?
  return true if item == possible_ancestor
  return true if parent == possible_ancestor
  return true if hierarchy(possible_ancestor).children.include?(item)
  ancestors?(possible_ancestor, parent)
end

def root?(item)  item.identifier == '/'  end
