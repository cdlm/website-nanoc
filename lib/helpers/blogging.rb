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
      # validate root
    end

    def identifier() @root.identifier end

    def entries
      return @entries unless @entries.nil?

      pattern = /^#{ @root[:entries] }$/
      @entries = @site.items.select { |i| pattern =~ i.identifier}
      @entries.sort_by! { |i| i[:created_at] || raise(RuntimeError, i.identifier) }
      return @entries
    end

    def chain_entries
      prev = nil
      entries.each do |i|
        unless prev.nil?
          prev[:next] = i.identifier
          i[:prev] = prev.identifier
        end
        prev = i
      end
    end

    def classified_by(&block)
      result = Hash.new do |hash,key| hash[key] = [] end
      entries.each do |i|
        key = yield i
        if key.is_a? Array
          key.each do |k| result[k] << i end
        else
          result[key] << i
        end
      end
      return result
    end
  end

end

include Blogging
