# -*- encoding : utf-8 -*-
usage 'publish'
aliases :p, :pub
summary 'shortcut for nanoc deploy -t public'

run do |opts, args, cmd|
  Nanoc::CLI.run %w{deploy -t public}
end
