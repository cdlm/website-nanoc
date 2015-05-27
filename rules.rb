# -*- encoding : utf-8 -*-

preprocess do

  # setup blog items
  all_feeds.each do |feed|
    feed.chain_entries
    feed.set_info
    feed.generate
  end

  # sitemap
  hide_items do |item|
    case item.identifier
    when %r{/publications/\d\d\d\d/.*}
      false
    when /404|500|htaccess/, %r{/(scripts|stylesheets)/.*}
      true
    else
      item.binary? || @config[:hidden_extensions].include?(item[:extension])
    end
  end
  create_sitemap
end

layout '*', :by_extension,
  haml: { format: :xhtml, ugly: true }

# do not generate partials, Sass includes, etc
ignore %r{/(_|README)}

# publications list from bibliography
compile '/publications/DamienPollet/', rep: :html do
  filter :external,
    cmd: [ 'bibhtmlize/bibhtmlize', item[:content_filename] ],
    pipe_content: false
end

route '/publications/DamienPollet/', rep: :html do  nil  end

# blog articles
ignore '/notes/**/*'
compile %r{/notes/\d\d\d\d/.*/} do
  case item[:extension]
  when 'html', 'markdown'
    filter :erb
    filter :kramdown
    filter :rubypants
    layout 'article'
    filter :relativize_paths, type: :html
  end
end

# default pipeline & routing
compile '*' do
  case item[:extension]
  when 'bib'
    # TODO filter out the BibDesk noise
  when /(.+\.)?js/
    # filter :closure_compiler
  when 'sass'
    filter :sass, style: :compact
    filter :relativize_paths, type: :css
  when 'erb', 'html', 'markdown'
    filter :erb
    filter :kramdown unless item[:extension] == 'erb'
    filter :rubypants
    layout 'default'
    filter :relativize_paths, type: :html
  when 'feed', 'xml'
    filter :erb
    # filter :relativize_paths, type: :xml
  end
end

route '*' do
  case item[:extension]
  when 'sass'
    extension 'css'
  when 'erb', 'html', 'markdown'
    extension 'html', as_index: true
  when 'feed'
    extension 'xml'
  else
    extension
  end
end
