# -*- encoding : utf-8 -*-
usage 'push'
aliases :gh, :'gh-pages'
summary 'deploy to github pages'

run do |opts, args, cmd|
  # sync output to the pages repo
  Nanoc::CLI.run %w{deploy -t default}

  require 'git'
  git = Git.open 'staging'
  begin
    git.add
    git.commit "Deploy on #{Time.now.to_s}", add_all: true
    git.push
  rescue Git::GitExecuteError => e
    puts e.message
  end
end
