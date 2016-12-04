class History < ActiveRecord::Base
  belongs_to :server
  belongs_to :client
  has_one :start_option
end
