# frozen_string_literal: true

# Fetch version of wrata application from git
# @return [String] version
def fetch_wrata_version
  version = `git describe 2>&1`
  # When shallow copy of repo, git describe return error
  # fatal: No names found, cannot describe anything.
  version = 'Unknown' if version.include?('fatal')
  version
rescue StandardError => e
  Rails.logger.warn("Cannot get wrata version with `#{e}` error")
  'Unknown'
end

Rails.application.config.wrata_version = fetch_wrata_version
