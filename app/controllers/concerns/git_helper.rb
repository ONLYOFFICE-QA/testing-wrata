# Stuff for working with git
module GitHelper
  # Change branch in directory
  # @param dir [String] directory with repo
  # @param branch [String] branch to set
  # @return [String] result of command
  def change_project_branch(dir, branch)
    `cd #{dir}; git checkout -f #{branch}; git pull;`
  end

  # List all branches in github repo
  # @param github_repo [String] repo to get branches
  # @return [Array, String] result of cleanup
  def get_list_branches(github_repo)
    branches = Rails.application.config.github_helper.branches(github_repo)
    promoted_master = promote_branch(branches, 'master')
    promote_branch(promoted_master, 'develop')
  end

  # Get list of tags in github repo
  # @param github_repo [String] repo to get tags
  # @return [Array, String] list of tags
  def get_tags(github_repo)
    Rails.application.config.github_helper.tags(github_repo)
  end

  # Get list of branches in project
  # @param project_path [String] path to project
  # @return [Array, String] list of branches
  def get_branches(project_path)
    system_message = `cd #{project_path}; git pull -q --prune; git checkout develop -qf; git branch -a`
    system_message.delete!('* ')
    system_message.split("\n")
  end

  private

  # Set branch in begin of list
  # @param branches [Array] list of branches
  # @param branch [String] branch to promote
  # @return [Array] with promoted
  def promote_branch(branches, branch)
    return branches unless branches.include?(branch)
    branches.delete branch
    branches.unshift branch
    branches
  end
end
