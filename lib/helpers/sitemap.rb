# -*- encoding : utf-8 -*-
include Nanoc::Helpers::XMLSitemap

def hide_items
  @items.each do |item|
    next if item.attributes.has_key?(:is_hidden)
    item[:is_hidden] = yield item
  end
end

def create_sitemap
  @items << Nanoc::Item.new(
    "<%= xml_sitemap %>",
    { :extension => 'xml', :is_hidden => true },
    '/sitemap/'
  )
end
