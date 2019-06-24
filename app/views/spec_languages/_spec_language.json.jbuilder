# frozen_string_literal: true

json.extract! spec_language, :id, :name, :created_at, :updated_at
json.url spec_language_url(spec_language, format: :json)
