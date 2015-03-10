class StartOption < ActiveRecord::Base
  belongs_to :history

  attr_accessible :docs_branch,
                  :teamlab_branch,
                  :shared_branch,
                  :teamlab_api_branch,
                  :portal_region,
                  :portal_type,
                  :start_command
end
