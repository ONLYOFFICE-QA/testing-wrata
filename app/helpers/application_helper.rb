require_relative "../../../SharedFunctional/Amazon/amazon_ec2_helper"
require_relative "../../../SharedFunctional/Amazon/amazon_test_executioner_options"
module ApplicationHelper

  def make_start_options_command(doc_branch, teamlab_branch, portal_region, portal_type)
    AmazonTestExecutionOptions.new(doc_branch, teamlab_branch, portal_region, portal_type)
    #"AmazonTestExecutionOptions.new(#{doc_branch},#{teamlab_branch},#{portal_region},#{portal_type})"
  end

  def make_start_list(test, options)
    AmazonEC2Helper.start_test_executioner("rspec '#{edit_file_path(test)}'", options)   #start on Amazon
    "AmazonEC2Helper.start_test_executioner(rspec '#{edit_file_path(test)}', #{options})" #for output into browser console
  end

  def edit_file_path(file_path)
    '~' + file_path.gsub(HOME_DIRECTORY, '')
  end

end