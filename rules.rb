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

layout '/**/*', :by_extension,
  haml: { format: :xhtml, ugly: true }

# do not generate partials, Sass includes, etc
ignore %r{/(_|README)}

# publications list from bibliography
compile '/publications/*.bib', rep: :html do
  filter :external,
    cmd: [ 'bibhtmlize/bibhtmlize', item[:content_filename] ],
    pipe_content: false
end

route '/publications/*.bib', rep: :html do  nil  end # FIXME

# blog articles
# ignore '/notes/**/*'
compile %r{/notes/\d\d\d\d/.*\.(html|markdown)$/} do
  filter :erb
  filter :kramdown
  filter :rubypants
  layout '/article.*'
  filter :relativize_paths, type: :html
end

compile '/**/*.sass' do
  filter :sass, style: :compact
  filter :relativize_paths, type: :css
end

compile '/**/*.{erb,html,markdown}' do
  filter :erb
  filter :kramdown unless item.identifier.extension == 'erb'
  filter :rubypants
  layout '/default.*'
  filter :relativize_paths, type: :html
end

compile '/**/*.{feed,xml}' do
  filter :erb
  # filter :relativize_paths, type: :xml
end

# default pipeline & routing
compile '/**/*' do
  # TODO *.bib: filter out the BibDesk noise
  # *.js: filter :closure_compiler
end

route '/**/*' do
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
