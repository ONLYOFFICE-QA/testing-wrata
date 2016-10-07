# Stuff for working with git
module GitHelper
  # Clean all stuff that may left by checkouts
  # @param dir [String] directory to cleanup
  # @return [String] result of cleanup
  def cleanup_project(dir)
    `cd #{dir}; git reset --hard; git clean -f; git pull;`
  end
end
