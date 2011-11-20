layout '*', :by_extension,
  :haml => { :ugly => true }

# do not generate partials, Sass includes, etc
compile %r{/(_|README)} do end
route %r{/(_|README)} do  nil  end

# blog articles
preprocess do
  all_feeds.each do |feed|
    feed.chain_entries
    feed.set_info
    feed.generate
  end
end

compile '/publications/DamienPollet/', :rep => :html do
  filter :external,
    :cmd => "bibhtmlize/bibhtmlize #{item[:content_filename]}",
    :pipe_content => false 
end

route '/publications/DamienPollet/', :rep => :html do  nil  end

compile %r{/notes/\d\d\d\d/.*/} do
  case item[:extension]
  when 'html', 'markdown'
    filter :erb
    layout 'article'
    filter :kramdown
    layout 'default'
    filter :rubypants
    filter :relativize_paths, :type => :html
  end
end

route '/notes/' do
  item.identifier + 'index.html'
end

# default pipeline & routing
compile '*' do
  case item[:extension]
  when 'bib'
    # TODO filter out the BibDesk noise
  when /(.+\.)?js/
    # filter :closure_compiler
  when 'sass'
    filter :sass, :style => :compact
    filter :relativize_paths, :type => :css
  when 'erb', 'html', 'markdown'
    filter :erb
    filter :kramdown unless item[:extension] == 'erb'
    layout 'default'
    filter :rubypants
    filter :relativize_paths, :type => :html
  end
end


route '*' do
  case item[:extension]
  when 'sass'
    extension 'css'
  when 'erb', 'markdown'
    extension 'html'
  else
    extension
  end
end

#  vim: set ts=2 sw=2 ts=2 :
