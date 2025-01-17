# frozen_string_literal: true

# Options of rspec to run with
# Like end test server location, branch, and other options
class StartOption < ApplicationRecord
  belongs_to :history

  # @return [String] full server region with server type
  def server_location
    return portal_type if portal_region.nil?

    "#{portal_type} #{portal_region}"
  end

  def create_options
    "#{update_projects_git(docs_branch)}" \
      "#{generate_region_command}"
  end

  def generate_region_command
    return '' if portal_type == 'default'
    return '' if on_custom_portal?

    portal_data_docs = '~/RubymineProjects/OnlineDocuments/data/portal_data.rb'
    portal_data_teamlab = '~/RubymineProjects/TeamLab/framework/static_data_teamlab.rb'
    region_command = ''
    region_command +=
      "#{sed_replace_config(portal_data_docs, '@create_portal_domain', ".#{portal_type}")} && " \
      "#{sed_replace_config(portal_data_docs, '@create_portal_region', portal_region)} && " \
      "#{sed_replace_config(portal_data_teamlab, '@@portal_type', ".#{portal_type}")} && " \
      "#{sed_replace_config(portal_data_teamlab, '@@server_region', portal_region)}"
    "#{region_command};"
  end

  # Check if current server options tells, that
  # this test should be run on custom portal
  # @return [True, False] is test should run on custom portal
  def on_custom_portal?
    %w[info com default].exclude?(portal_type)
  end

  # @param test [Hash] test with data to init
  def self.from_test(test)
    StartOption.new(docs_branch: test[:doc_branch],
                    teamlab_branch: test[:tm_branch],
                    portal_type: test[:location].split[0],
                    portal_region: test[:location].split[1],
                    spec_browser: test[:spec_browser],
                    spec_language: test[:spec_language])
  end

  # @return [String] remove all sensitive data from start command
  def safe_start_command
    start_command&.gsub(Rails.application.credentials.ssh_pass, '[SSH_PASS]')
  end

  private

  # @param branch [String] branch to use
  # @return [String] command for update all projects
  def update_projects_git(branch)
    command = ''
    projects = Project.all

    projects.each do |project|
      command += project.update_git_command(branch)
    end

    command
  end

  # Sed command for updating config files
  # @param file [String] file to update
  # @param key [String] key to update
  # @param value [String] value to set
  # @return [String] sed command
  def sed_replace_config(file, key, value)
    "sed -i \\\"s/#{key} = '.*'/#{key} = '#{value}'/g\\\" #{file}"
  end
end
