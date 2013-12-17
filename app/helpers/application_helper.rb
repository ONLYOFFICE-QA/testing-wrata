require_relative "../../../SharedFunctional/Amazon/amazon_ec2_helper"
require_relative "../../../SharedFunctional/Amazon/amazon_test_executioner_options"
module ApplicationHelper

  def get_branches(project, branch, region)
    teamlab_branch = TEAMLAB_DEFAULT_BRANCH
    doc_branch = DOCS_DEFAULT_BRANCH
    if project == DOCS_TAB_NAME
      doc_branch = branch
      if region == INFO_SERVER
        teamlab_branch = TEAMLAB_INFO_MAIN_BRANCH
      elsif  region == COM_SERVER
        teamlab_branch = TEAMLAB_COM_MAIN_BRANCH
      end
    end
    if project == TEAMLAB_TAB_NAME
      teamlab_branch = branch
    end
    return doc_branch, teamlab_branch
  end

  def make_start_options_command(doc_branch, teamlab_branch, portal_region, portal_type)
    AmazonTestExecutionOptions.new(doc_branch, teamlab_branch, portal_region, portal_type)
    #"AmazonTestExecutionOptions.new(#{doc_branch},#{teamlab_branch},#{portal_region},#{portal_type})"
  end

  def make_start_list(test, options)
    AmazonEC2Helper.start_test_executioner("rspec '#{edit_file_path(test)}'", options)   #start on Amazon
    "AmazonEC2Helper.start_test_executioner(rspec '#{edit_file_path(test)}', #{options})" #for output into browser console
  end

  def make_start_list_with_stroke(test, strokes, options)

    AmazonEC2Helper.start_test_executioner("#{create_path_with_stroke(test, strokes)}", options)             #start on Amazon
    "AmazonEC2Helper.start_test_executioner('#{create_path_with_stroke(test, strokes)}', #{options})"        #for output into browser console
  end

  def create_path_with_stroke(test, strokes)                                      #
    command = ''                                                                  #FOR
    strokes.each do |stroke|                                                      #
      command += "rspec #{edit_file_path(test)}:#{stroke[1]['number']};"          #AMAZON
    end                                                                           #
    command
  end

  def create_path_with_stoke_local(test, strokes)
    command = ''                                                                #
    strokes.each_with_index do |stroke, index|                                  #
      if index == 0                                                             #FOR
        command += "#{edit_file_path(test)}:#{stroke[1]['number']};"            #
      else                                                                      #LOCAL
        command += "rspec #{edit_file_path(test)}:#{stroke[1]['number']};"      #
      end                                                                       #MACHINE
    end                                                                         #
    command
  end

  def save_history(file_name, db_user, client)
    history = History.new()
    history.file = file_name.gsub(RUBYMINE_PROJECTS_PATH, '')
    history.user = db_user

    unless client.nil?
      history.client = client
    end
    history.save
    history
  end

  def save_history_with_stroke(file_name, strokes, db_user, client)
    file_name = file_name + ':'
    strokes.each do |stroke|
      file_name += "#{stroke[1]['number']},"
    end
    history = History.new()
    history.file = file_name
    history.user = db_user
    unless client.nil?
      history.client = client
    end
    history.save
    history
  end

  def edit_file_path(file_path)
    '~' + file_path.gsub(HOME_DIRECTORY, '')
  end

end