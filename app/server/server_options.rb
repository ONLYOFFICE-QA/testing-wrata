class ServerOptions

  attr_accessor :portal_type, :portal_region, :docs_branch, :teamlab_branch, :teamlab_api_branch, :shared_branch

  def initialize(docs_branch = 'develop', teamlab_branch = 'master', portal_type = 'info', portal_region = 'us',  shared_branch = 'master', teamlab_api_branch = TM_API_DEFAULT)
    @docs_branch = docs_branch
    @teamlab_branch = teamlab_branch
    @shared_branch = shared_branch
    @teamlab_api_branch = teamlab_api_branch
    @portal_type = portal_type
    @portal_region = portal_region
  end

  def create_options
    @teamlab_branch = 'master' if @docs_branch == 'master'
    command =  "cd ~/RubymineProjects/OnlineDocuments && git reset --hard && git pull && git checkout #{@docs_branch} && git pull && bundle install && " +
        "cd ~/RubymineProjects/SharedFunctional && git reset --hard && git pull && git checkout #{@shared_branch} && git pull && bundle install && " +
        "cd ~/RubymineProjects/TeamLab && git reset --hard && git pull && git checkout #{@teamlab_branch} && git pull && bundle install && " +
        "cd ~/RubymineProjects/TeamLabAPI2 && git reset --hard && git pull && git checkout #{@teamlab_api_branch} && git pull && " +
        "#{generate_region_command} "
    #"cd ~/RubymineProjects/OnlineDocuments && git reset --hard && git pull && git checkout #{@docs_branch} && git pull && bundle install && " +
    #    "cd ~/RubymineProjects/SharedFunctional && git reset --hard && git pull && git checkout #{@shared_branch} && git pull && bundle install && " +
    #    "cd ~/RubymineProjects/TeamLab && git reset --hard && git pull && git checkout #{@teamlab_branch} && git pull && bundle install && " +
    #    "cd ~/RubymineProjects/TeamLabAPI2 && git reset --hard && git pull && git checkout #{@teamlab_api_branch} && git pull && " +
    #    "#{generate_region_command} "
    command
  end

  def generate_region_command
    portal_data_docs = '~/RubymineProjects/OnlineDocuments/data/portal_data.rb'
    portal_data_teamlab = '~/RubymineProjects/TeamLab/Framework/StaticDataTeamLab.rb'
    create_portal = if @portal_type == 'isa'
                      "sed -i \\\"s/@create_portal = true/@create_portal = false/g\\\" #{portal_data_docs} && "
                    else
                      "sed -i \\\"s/@create_portal = false/@create_portal = true/g\\\" #{portal_data_docs} && "
                    end
    create_portal +
        "sed -i \\\"s/@create_portal_domain = '.info'/@create_portal_domain = '.#{@portal_type}'/g\\\" #{portal_data_docs} && " +
        "sed -i \\\"s/@create_portal_domain = '.com'/@create_portal_domain = '.#{@portal_type}'/g\\\" #{portal_data_docs} && "  +
        "sed -i \\\"s/@create_portal_region = 'us'/@create_portal_region = '#{@portal_region}'/g\\\" #{portal_data_docs} && " +
        "sed -i \\\"s/@create_portal_region = 'eu'/@create_portal_region = '#{@portal_region}'/g\\\" #{portal_data_docs} && " +
        "sed -i \\\"s/@create_portal_region = 'sg'/@create_portal_region = '#{@portal_region}'/g\\\" #{portal_data_docs} && " +
        "sed -i \\\"s/@@portal_type = '.info'/@@portal_type = '.#{@portal_type}'/g\\\" #{portal_data_teamlab} && " +
        "sed -i \\\"s/@@portal_type = '.com'/@@portal_type = '.#{@portal_type}'/g\\\" #{portal_data_teamlab} && "  +
        "sed -i \\\"s/@@server_region = 'us'/@@server_region = '#{@portal_region}'/g\\\" #{portal_data_teamlab} && " +
        "sed -i \\\"s/@@server_region = 'eu'/@@server_region = '#{@portal_region}'/g\\\" #{portal_data_teamlab} && " +
        "sed -i \\\"s/@@server_region = 'sg'/@@server_region = '#{@portal_region}'/g\\\" #{portal_data_teamlab} && " +
        "sed -i \\\"s/@@server_region= 'us'/@@server_region= '#{@portal_region}'/g\\\" #{portal_data_teamlab} && " +
        "sed -i \\\"s/@@server_region= 'eu'/@@server_region= '#{@portal_region}'/g\\\" #{portal_data_teamlab} "
        "sed -i \\\"s/@@server_region= 'sg'/@@server_region= '#{@portal_region}'/g\\\" #{portal_data_teamlab} "
  end

  def to_hash
    hash = {}
    instance_variables.each do |var|
      hash[var.to_s.delete('@')] = self.instance_variable_get(var)
    end
    hash
  end

end