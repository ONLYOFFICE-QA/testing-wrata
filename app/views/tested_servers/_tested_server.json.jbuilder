json.extract! tested_server, :id, :url, :created_at, :updated_at
json.url tested_server_url(tested_server, format: :json)
