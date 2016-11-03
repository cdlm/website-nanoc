# rubocop:disable AlignParameters, BlockDelimiters, EmptyLinesAroundBlockBody

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
      item.binary? || @config[:hidden_extensions].include?(item.identifier.ext)
    end
  end
  create_sitemap
end

layout '/**/*.haml', :haml, format: :xhtml, ugly: true
layout '/**/*', :erb

# do not generate partials, Sass includes, etc
ignore %r{/(_|README)}

# publications list from bibliography
compile '/publications/*.bib', rep: :html do
  filter :external,
    cmd: ['bibhtmlize/bibhtmlize', item[:content_filename]],
    pipe_content: false
end

route '/publications/*.bib', rep: :html do  nil  end # FIXME

# blog articles
compile %r{\A/notes/\d{4}/.*\.(html|markdown)\z} do
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

route '/**/*.sass' do
  extension 'css'
end

compile '/**/*.{erb,html,markdown}' do
  filter :erb
  filter :kramdown unless item.identifier.ext == 'erb'
  filter :rubypants
  layout '/default.*'
  filter :relativize_paths, type: :html
  # filter :html5small
end

route '/**/*.{erb,html,markdown}' do
  extension 'html', as_index: true
end

compile '/**/*.{feed,xml}' do
  filter :erb
  # filter :relativize_paths, type: :xml
end

route '/**/*.feed' do
  extension 'xml'
end

# default pipeline & routing
compile '/**/*' do
  # TODO: unhandled extensions
  # *.bib: filter out the BibDesk noise
  # *.js: filter :closure_compiler
end

route '/**/*' do
  extension
end
