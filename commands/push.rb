# -*- encoding : utf-8 -*-
usage 'push'
aliases :gh, :'gh-pages'
summary 'deploy to github pages'

run do |opts, args, cmd|
  require 'git'
  git = Git.open 'staging'
  begin
    touched = [git.status.added, git.status.changed, git.status.deleted, git.status.untracked]
    if touched.all? { |each| each.empty? }
        Nanoc::CLI::Logger.instance.log(:low, "No changes to push")
    else
      git.add
      git.commit "Deploy on #{Time.now.to_s}", add_all: true
      Nanoc::CLI::Logger.instance.log(:low, "Pushing deploy commit #{git.revparse(git.current_branch)}…")
      git.push
    end
  rescue Git::GitExecuteError => e
    puts e.message
  end
end
