# -*- encoding : utf-8 -*-

class GitPush < Nanoc::Extra::Deployer
  identifier :git

  def run
    require 'git'

    working_dir = File.expand_path( self.config.fetch(:working_dir, source_path) )
    error "Incorrect working directory #{working_dir}" unless File.directory? working_dir

    logger = Nanoc::CLI::Logger.instance
    git = Git.open source_path
    begin
      touched = {
        added: [ git.status.added, git.status.changed, git.status.untracked ],
        removed: [ git.status.deleted ]
      }
      if touched.all? { |k,each| each.empty? }
          logger.log(:low, "No changes to push")
      else
        if self.dry_run?
          touched.each do |e| logger.log(:low, e.join(' ')) end
        else
          git.add
          git.commit "Deploy on #{Time.now.to_s}", add_all: true
          logger.log(:low, "Pushing deploy commit #{git.revparse(git.current_branch)}…")
          git.push
        end
      end
    rescue Git::GitExecuteError => e
      error e.message
    end
  end
end
