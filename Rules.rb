layout 'default', :haml
layout '*', :erb

compile /\/_/ do end

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

route /\/_/ do # do not generate partials, Sass includes, etc
  nil
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

