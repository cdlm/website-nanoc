module Blogging

  # Convenience
  class Nanoc::MutableItemView
    def feed?
       self[:kind] == 'feed' || self[:extension] == 'feed'
    end
  end

  ## Content helpers

  def article_image(item)
    image_id = item[:image] and item_named image_id
  end

  ## Preprocessing stage
  def all_feeds
    Enumerator.new do |feeds|
      @items.each do |i|
        feeds << Feed.new(@items, i) if i.feed?
      end
    end
  end

  def feed_named(id)
    item = @items[id] and item.feed? or return nil
    Feed.new(@items, item)
  end


  class Feed

    def initialize(site_items, root)
      @site_items = site_items
      @root = root
      @entries = nil
      # TODO validate root
    end

    def entries
      return @entries unless @entries.nil?

      pattern = /^#{ @root[:entries_pattern] }$/
      @entries = @site_items.select { |i| pattern =~ i.identifier }
      @entries.sort_by! { |i| i[:created_at] || raise(RuntimeError, i.identifier) }
      return @entries
    end

    def entries_by_year
      classified_entries{ |e| e[:created_at].year.to_s }
    end

    def mtime(items=nil)
      (items || self.entries).collect{ |e| e[:mtime] }.max
    end

    def chain_entries
      prev = nil
      entries.each do |current|
        unless prev.nil?
          prev[:next] = current.identifier
          current[:prev] = prev.identifier
        end
        prev = current
      end
    end

    def set_info
      entries.each do |e|
        # e.attributes.update(@root[:entries_info])
        @root[:entries_info].each do |attribute, value|
          e[attribute] = value
        end
      end
    end

    def generate
      create_archive_item unless @root[:archives].nil?
      create_yearly_archive_items unless @root[:archives_yearly].nil?
      create_tag_item unless @root[:tags].nil?
    end

    def create_archive_item
      contents = entries_by_year
      create_classification_item(contents, mtime, @root[:archives])
    end

    def create_yearly_archive_items
      years = entries_by_year
      years.each do |y, es|
        create_classification_item({y => es}, mtime(es), @root[:archives_yearly], single_year: y)
      end
    end

    def create_tag_item
      contents, unsorted_tags = {}, classified_entries{ |e| e[:tags] }
      unsorted_tags.keys.sort.each do |t|
        contents[t] = unsorted_tags[t]
      end
      create_classification_item(contents, mtime, @root[:tags])
    end

    def classified_entries(reverse=true, &block)
      result = Hash.new
      (reverse ? entries.reverse : entries).each do |i|
        key = yield i
        if key.is_a? Array
          key.each do |k|
            (result[k] ||= []) << i
          end
        else
          (result[key] ||= []) << i
        end
      end
      return result
    end

    def create_classification_item(contents, mtime, options, args={})
      attributes = {
        contents: contents,
        mtime: mtime,
        extension: 'erb',
        is_hidden: true
      }
      options[:attributes].each do |k,v|
        attributes[k] = v % args
      end

      @site_items.create(
        "<%= render '#{options[:layout]}' %>",
        attributes,
        options[:identifier] % args)
    end

  end
end

include Blogging
#  vim: set ts=2 sw=2 ts=2 :
