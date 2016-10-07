# Stuff for working with git
module GitHelper
  # Change branch in directory
  # @param dir [String] directory with repo
  # @param branch [String] branch to set
  # @return [String] result of command
  def change_project_branch(dir, branch)
    `cd #{dir}; git checkout -f #{branch}; git pull;`
  end

  # Clean all stuff that may left by checkouts
  # @param dir [String] directory to cleanup
  # @return [String] result of cleanup
  def cleanup_project(dir)
    `cd #{dir}; git reset --hard; git clean -f; git pull;`
  end

  # List all branches in git repo
  # @param project_path [String] directory to get branches
  # @return [Array, String] result of cleanup
  def get_list_branches(project_path)
    system_message = `cd #{project_path}; git pull --prune; git checkout -f develop; git branch -a`
    branches = []
    system_message.to_s.gsub!('* ', '')
    system_message.to_s.split("\n  ").each do |line|
      branches << line.to_s.split(' ')
    end
    branches.flatten!
    branches.delete '->'
    branches_name = []
    branches.each do |branch|
      if branch.include?('/') && branch.include?('remote')
        branches_name << branch.gsub('remotes/origin/', '')
        next
      end
    end
    branches_name.delete 'develop'
    branches_name.unshift 'develop'
    branches_name
  end

  # Get list of tags in project
  # @param project_path [String] path to project
  # @return [Array, String] list of tags
  def get_tags(project_path)
    system_message = `cd #{project_path}; git pull --prune -q; git checkout develop -qf; git tag -l`
    system_message.split("\n")
  end
end
