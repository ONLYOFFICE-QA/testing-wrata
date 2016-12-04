class StartOption < ActiveRecord::Base
  belongs_to :history

  # @return [String] full server region with server type
  def server_location
    return portal_type if portal_region.nil?
    "#{portal_type} #{portal_region}"
  end
end
