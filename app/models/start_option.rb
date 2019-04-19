class StartOption < ActiveRecord::Base
  belongs_to :history

  # @return [String] full server region with server type
  def server_location
    return portal_type if portal_region.nil?

    "#{portal_type} #{portal_region}"
  end

  def create_options
    command = "cd ~/RubymineProjects/SharedFunctional && git reset --hard && git pull --all --prune && git checkout #{shared_branch} && bundle install; " \
              "cd ~/RubymineProjects/TeamLabAPI2 && git reset --hard && git pull --all --prune && git checkout #{teamlab_api_branch}; " \
              "#{update_projects_git(docs_branch)}" \
              "#{generate_region_command}"
    command
  end

  def generate_region_command
    return '' if portal_type == 'default'

    portal_data_docs = '~/RubymineProjects/OnlineDocuments/data/portal_data.rb'
    portal_data_teamlab = '~/RubymineProjects/TeamLab/Framework/StaticDataTeamLab.rb'
    region_command = ''
    region_command +=
      "sed -i \\\"s/@create_portal_domain = '.*'/@create_portal_domain = '.#{portal_type}'/g\\\" #{portal_data_docs} && " \
      "sed -i \\\"s/@create_portal_region = '.*'/@create_portal_region = '#{portal_region}'/g\\\" #{portal_data_docs} && " \
      "sed -i \\\"s/@@portal_type = '.*'/@@portal_type = '.#{portal_type}'/g\\\" #{portal_data_teamlab} && " \
      "sed -i \\\"s/@@server_region = '.*'/@@server_region = '#{portal_region}'/g\\\" #{portal_data_teamlab}"
    "#{region_command};"
  end

  # Check if current server options tells, that
  # this test should be run on custom portal
  # @return [True, False] is test should run on custom portal
  def on_custom_portal?
    !(portal_type == 'info' || portal_type == 'com' || portal_type == 'default')
  end

  # @param test [Hash] test with data to init
  def self.from_test(test)
    StartOption.new(docs_branch: test[:doc_branch],
                    teamlab_branch: test[:tm_branch],
                    portal_type: test[:location].split(' ')[0],
                    portal_region: test[:location].split(' ')[1],
                    spec_browser: test[:spec_browser],
                    spec_language: test[:spec_language])
  end

  private

  # @param branch [String] branch to use
  # @return [String] command for update all projects
  def update_projects_git(branch)
    command = ''
    projects = Project.all

    projects.each do |project|
      command << project.update_git_command(branch)
    end

    command
  end
end
