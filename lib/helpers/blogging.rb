module Blogging

  def feed?(item)
    item[:kind] == 'feed' || item.identifier.ext == 'feed'
  end

  ## Content helpers

  def article_image(item)
    image_id = item[:image] and item_named image_id # rubocop:disable AndOr
  end

  ## Preprocessing stage
  def all_feeds
    Enumerator.new do |feeds|
      @items.each do |i|
        feeds << Feed.new(@items, i) if feed?(i)
      end
    end
  end

  def feed_named(id)
    item = @items[id] and feed?(item) or fail("No feed at #{id}") # rubocop:disable AndOr
    Feed.new(@items, item)
  end


  class Feed

    def initialize(site_items, root)
      @site_items = site_items
      @root = root
      @entries = nil
      # TODO: validate root
    end

    def entries
      return @entries unless @entries.nil?

      @entries = @site_items
        .find_all(@root[:entries_pattern])
        .reject { |i| i[:is_generated] }
        .sort_by { |i|
          i[:created_at] || fail("Item #{i.identifier}" \
            ' is missing mandatory attribute created_at')
        }
    end

    def entries_by_year
      classified_entries { |e| [e[:created_at].year] }
    end

    def mtime(ids = nil)
      specific_items = ids.nil? ? entries : ids.map { |id| @site_items[id] }
      specific_items.collect { |e| e[:mtime] }.max
    end

    def chain_entries
      prev = nil
      entries.each do |current|
        unless prev.nil?
          prev[:next] = current.identifier.to_s
          current[:prev] = prev.identifier.to_s
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
      years.each do |year, entries|
        create_classification_item(
          { year => entries }, mtime(entries),
          @root[:archives_yearly],
          single_year: year)
      end
    end

    def create_tag_item
      contents = {}
      unsorted_tags = classified_entries { |e| e[:tags] }
      unsorted_tags.keys.sort.each do |t|
        contents[t] = unsorted_tags[t]
      end
      create_classification_item(contents, mtime, @root[:tags])
    end

    def classified_entries(reverse = true)
      result = {}
      (reverse ? entries.reverse : entries).each do |item|
        keys = yield item
        keys = [keys] unless keys.is_a? Array
        keys.each do |k| (result[k] ||= []) << item.identifier.to_s end
      end
      result
    end

    def create_classification_item(contents, mtime, options, args = {})
      attributes = {
        contents: contents,
        mtime: mtime,
        is_generated: true,
        is_hidden: true
      }
      options[:attributes].each do |k, v|
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
