module BullshitHelper
  def self.match_minutes_and_hours(method)
    hours = method.match(/_(\d*)_hours/)
    hours = hours.captures.first if hours
    minutes = method.match(/_(\d*)_minutes/)
    minutes = minutes.captures.first if minutes
    [hours, minutes]
  end
end
