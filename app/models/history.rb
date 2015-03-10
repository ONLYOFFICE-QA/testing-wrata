class History < ActiveRecord::Base
  belongs_to :server
  belongs_to :client
  has_one :start_option

  attr_accessible :log, :file, :user_id, :client_id, :analysed, :total_results
end
