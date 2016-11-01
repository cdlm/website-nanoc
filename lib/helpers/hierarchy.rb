module Hierarchy

  def hierarchy(item)
    ItemHierarchy.new(@items, item)
  end

  # Attribute lookup
  def info(key, item=nil)
    item ||= @item
    item.fetch(key) do
      parent = hierarchy(item).parent
      if parent.nil?
        @config[:default_info].fetch(key) { @config[key] }
      else
        info key, parent
      end
    end
  end

  class ItemHierarchy
    attr_reader :subject

    def initialize(items, subject_item)
      @items, @subject = items, subject_item
    end

    def parent
      canonicalized_path = subject.identifier.without_ext.sub(/\/index$/, '')
      return nil if canonicalized_path.empty?
      path_without_last_component = canonicalized_path.sub(/\/[^\/]+$/, '')
      @items[path_without_last_component + '{,/index}.*']
    end

    def children
      pattern = subject.identifier.without_ext.sub(/\/index$/, '') + '/*'
      @items.find_all(pattern)
    end
  end
end

include Hierarchy
