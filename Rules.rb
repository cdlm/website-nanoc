layout '_*', :erb
layout '*', :haml

# do not generate partials, Sass includes, etc
compile %r{/_} do end
route %r{/_} do  nil  end

# blog articles
preprocess do
  
end

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
  when 'js'
    filter :closure_compiler
  when 'sass'
    filter :sass, :style => :compact
    filter :relativize_paths, :type => :css
  when 'html', 'markdown'
    filter :erb
    filter :kramdown
    layout 'default'
    filter :rubypants
    filter :relativize_paths, :type => :html
  end
end


route '*' do
  case item[:extension]
  when 'sass'
    extension 'css'
  when 'markdown'
    extension 'html'
  else
    extension
  end
end

