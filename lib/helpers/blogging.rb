module Blogging

  ## Content helpers

  def article_image(item)
    item_named item[:image]
  end

  ## Preprocessing stage
  def all_feeds
    feed_items = @items.select { |i|
      i[:kind] == 'feed' or i[:extension] == 'feed'
    }
    feed_items.collect { |i| Feed.new(@site, i) }
  end

  def feed_named(id)
    all_feeds.find { |f| f.identifier == id }
  end


  class Feed

    def initialize(site, root)
      @site = site
      @root = root
      @entries = nil
      # TODO validate root
    end

    def identifier()  @root.identifier  end

    def [](key)  @root[key]  end

    def []=(key, value)  @root[key] = value  end

    def entries
      return @entries unless @entries.nil?

      pattern = /^#{ @root[:entries] }$/
      @entries = @site.items.select { |i| pattern =~ i.identifier}
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
          prev[:next] = current
          current[:prev] = prev
        end
        prev = current
      end
    end

    def set_info
      entries.each do |e|
        e.attributes.update(self[:entries_info])
      end
    end

    def generate
      @site.items << archive_item unless self[:archives].nil?
      @site.items.concat yearly_archive_items unless self[:archives_yearly].nil?
      @site.items << tag_item unless self[:tags].nil?
    end

    def archive_item
      contents = entries_by_year
      return classification_item(contents, mtime, self[:archives])
    end

    def yearly_archive_items
      years = entries_by_year
      return years.collect{ |y, es|
        classification_item({y => es}, mtime(es), self[:archives_yearly], year: y)
      }
    end

    def tag_item 
      contents, unsorted_tags = {}, classified_entries{ |e| e[:tags] }
      unsorted_tags.keys.sort.each do |t|
        contents[t] = unsorted_tags[t]
      end
      return classification_item(contents, mtime, self[:tags])
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

    def classification_item(contents, mtime, options, args={})
      attributes = {
        contents: contents,
        mtime: mtime,
        extension: 'erb',
        is_hidden: true
      }
      options[:attributes].each do |k,v|
        attributes[k] = v % args
      end

      return Nanoc3::Item.new(
        "<%= render '#{options[:layout]}' %>",
        attributes,
        options[:identifier] % args)
    end

  end
end

include Blogging
#  vim: set ts=2 sw=2 ts=2 :
