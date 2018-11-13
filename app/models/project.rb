class Project < ApplicationRecord
  # @param branch [String] branch to update
  # @return [String] bash command to update git
  def update_git_command(branch)
    "cd #{project_path} && git reset --hard && git pull --all --prune && git checkout #{branch} && bundle install; "
  end

  # @return [String] path to project
  def project_path
    return '~/RubymineProjects/OnlineDocuments' if name == 'ONLYOFFICE/testing-documentserver' # legacy project name
    return '~/RubymineProjects/TeamLab' if name == 'ONLYOFFICE/testing-onlyoffice' # legacy project name

    name.split('/').last
  end
end
