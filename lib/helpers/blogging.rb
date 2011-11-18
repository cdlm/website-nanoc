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

    def chain_entries
      prev = nil
      entries.each do |i|
        unless prev.nil?
          prev[:next] = i #.identifier
          i[:prev] = prev #.identifier
        end
        prev = i
      end
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
  end

  def generate
    @site.items.concat archive_items
    @site.items.concat tag_items
  end

  def archive_items
    return [] if self[:archives].nil?

    identifier = self[:archives][:identifier]
    layout     = self[:archives][:layout]
    attributes = { :extension => 'erb', :mtime => entries.collect{ |e| e[:mtime] }.max }
    attributes.update(self[:archives][:attributes])

    years = classified_entries{ |e| e[:created_at].year }

    content = years.collect do |year, posts|
      post_ids = posts.collect{ |e| e.identifier }
      "<%= render '#{layout}', :year => '#{year}', :posts => ['#{post_ids.join("', '")}'] %>"
    end
    archive_page = Nanoc3::Item.new(content.join("\n"), attributes, identifier)

    return [archive_page]
  end

  def tag_items
    return [] if self[:tags].nil?

    identifier = self[:tags][:identifier]
    layout     = self[:tags][:layout]
    attributes = { :extension => 'erb', :mtime => entries.collect{ |e| e[:mtime] }.max }
    attributes.update(self[:archives][:attributes])

    unsorted_tags = classified_entries{ |e| e[:tags] }
    tags = {}
    unsorted_tags.keys.sort.each do |t| tags[t] = unsorted_tags[t] end

    content = tags.collect do |tag, posts|
      post_ids = posts.collect{ |e| e.identifier }
      "<%= render '#{layout}', :tag => '#{tag}', :posts => ['#{post_ids.join("', '")}'] %>"
    end
    tag_page = Nanoc3::Item.new(content.join("\n"), attributes, identifier)

    return [tag_page]
  end

end

include Blogging
#  vim: set ts=2 sw=2 ts=2 :
