class ServerOptions
  attr_accessor :portal_type, :portal_region, :docs_branch, :teamlab_branch, :teamlab_api_branch, :shared_branch

  def initialize(docs_branch = 'develop', teamlab_branch = 'master', portal_type = 'info', portal_region = 'us', shared_branch = 'master', teamlab_api_branch = TM_API_DEFAULT)
    @docs_branch = docs_branch
    @teamlab_branch = teamlab_branch
    @shared_branch = shared_branch
    @teamlab_api_branch = teamlab_api_branch
    @portal_type = portal_type
    @portal_region = portal_region
  end

  def create_options
    @teamlab_branch = 'master' if @docs_branch == 'master'
    @docs_branch = 'master' if @teamlab_branch == 'master'
    command = "cd ~/RubymineProjects/SharedFunctional && git reset --hard && git pull --all --prune && git checkout #{@shared_branch} && bundle install && " \
        "cd ~/RubymineProjects/OnlineDocuments && git reset --hard && git pull --all --prune && git checkout #{@docs_branch} && bundle install && " \
        "cd ~/RubymineProjects/TeamLab && git reset --hard && git pull --all --prune && git checkout #{@teamlab_branch} && bundle install && " \
        "cd ~/RubymineProjects/TeamLabAPI2 && git reset --hard && git pull --all --prune && git checkout #{@teamlab_api_branch} && " \
        "#{generate_region_command} "
    command
  end

  def generate_region_command
    portal_data_docs = '~/RubymineProjects/OnlineDocuments/data/portal_data.rb'
    portal_data_teamlab = '~/RubymineProjects/TeamLab/Framework/StaticDataTeamLab.rb'
    create_portal = if @portal_type == 'default'
                      "sed -i \\\"s/@create_portal = true/@create_portal = false/g\\\" #{portal_data_docs}"
                    else
                      "sed -i \\\"s/@create_portal = false/@create_portal = true/g\\\" #{portal_data_docs}"
                    end
    region_command = create_portal
    unless @portal_type == 'default'
      region_command +=
        " && sed -i \\\"s/@create_portal_domain = '.*'/@create_portal_domain = '.#{@portal_type}'/g\\\" #{portal_data_docs} && " \
        "sed -i \\\"s/@create_portal_region = '.*'/@create_portal_region = '#{@portal_region}'/g\\\" #{portal_data_docs} && " \
        "sed -i \\\"s/@@portal_type = '.*'/@@portal_type = '.#{@portal_type}'/g\\\" #{portal_data_teamlab} && " \
        "sed -i \\\"s/@@server_region = '.*'/@@server_region = '#{@portal_region}'/g\\\" #{portal_data_teamlab} "
    end
    region_command
  end

  def to_hash
    hash = {}
    instance_variables.each do |var|
      hash[var.to_s.delete('@')] = instance_variable_get(var)
    end
    hash
  end

  # Check if current server options tells, that
  # this test should be run on custom portal
  # @return [True, False] is test should run on custom portal
  def on_custom_portal?
    !(@portal_type == 'info' || @portal_type == 'com' || @portal_type == 'default')
  end
end
