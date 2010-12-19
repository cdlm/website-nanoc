# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::Rendering

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
  info(:menu).collect do |each|
    items.find { |any| any.identifier == each }
  end
end
