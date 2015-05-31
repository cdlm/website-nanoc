include Nanoc::Helpers::XMLSitemap

def hide_items
  @items.each do |item|
    next if item.key?(:is_hidden)
    item[:is_hidden] = yield item
  end
end

def create_sitemap
  @items.create(
    "<%= xml_sitemap %>",
    { :is_hidden => true },
    '/sitemap.xml'
  )
end
