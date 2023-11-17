# frozen_string_literal: true

# Fetch version of wrata application from git
# @return [String] version
def fetch_wrata_version
  `git describe`
rescue StandardError => e
  Rails.logger.warn("Cannot get wrata version with `#{e}` error")
  'Unknown'
end

Rails.application.config.wrata_version = fetch_wrata_version
