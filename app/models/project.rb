# frozen_string_literal: true

# GitHub project for whom tests should be run and file list should be rendered
class Project < ApplicationRecord
  validates :name, uniqueness: true, length: { maximum: 256 }

  # @param branch [String] branch to update
  # @return [String] bash command to update git
  def update_git_command(branch)
    "echo Start updating #{project_path} project; " \
      "cd #{project_path} && " \
      'git reset --hard && ' \
      'git pull --all --prune && ' \
      "git checkout #{branch} && " \
      'bundle install; ' \
      "echo Finished updating #{project_path} project; "
  end

  # @return [String] path to project
  def project_path
    return '~/RubymineProjects/OnlineDocuments' if name == 'ONLYOFFICE/testing-documentserver' # legacy project name
    return '~/RubymineProjects/TeamLab' if name == 'ONLYOFFICE/testing-onlyoffice' # legacy project name

    "~/RubymineProjects/#{name.split('/').last}"
  end
end
