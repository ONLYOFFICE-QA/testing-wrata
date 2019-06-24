# frozen_string_literal: true

json.extract! spec_browser, :id, :name, :created_at, :updated_at
json.url spec_browser_url(spec_browser, format: :json)
