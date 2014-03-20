class DelayedRun < ActiveRecord::Base
  belongs_to :client
  attr_accessible :name, :f_type, :method, :client_id, :start_time, :next_start
end
