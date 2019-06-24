# frozen_string_literal: true

json.array!(@histories) do |history|
  json.extract! history, :id
  json.url history_url(history, format: :json)
end
