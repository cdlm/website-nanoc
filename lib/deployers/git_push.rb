# -*- encoding : utf-8 -*-

# A deployer that pushes the compiled site using git.
#
# The path to the root of the git working directory should be specified in the
# deployment configuration, using the `working_dir` value (which defaults to
# the same as nanoc's `output_dir`).  This deployer will simply commit all
# changes to the files there, including new and removed files, then push to the
# default upstream branch.
#
# The user should ensure that `working_dir` points to a git working repository
# (i.e. containing `.git`), and that the branch tracking is set up so that it
# can be pushed without arguments (a simple `git push` should work).
#
# @example A deployment configuration using the `:git` deployer
#   deploy:
#     public:
#       kind: git
#       working_dir: output
#
# @todo Specify commit branch, commit message template, and push refspec.
# @author Damien Pollet
class GitPush < Nanoc::Extra::Deployer
  identifier :git

  # @see Nanoc::Extra::Deployer#run
  def run
    require 'git'

    working_dir = File.expand_path( self.config.fetch(:working_dir, source_path) )
    error "Incorrect working directory #{working_dir}" unless File.directory? working_dir

    logger = Nanoc::CLI::Logger.instance
    git = Git.open working_dir
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
