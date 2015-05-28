class History < ActiveRecord::Base
  belongs_to :server
  belongs_to :client
  has_one :start_option

  attr_accessible :log, :file, :server_id, :client_id, :analysed, :total_result
end
