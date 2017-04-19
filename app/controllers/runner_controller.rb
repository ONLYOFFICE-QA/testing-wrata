require 'find'

class RunnerController < ApplicationController
  include GitHelper

  def index
    @controller = :runner
  end

  def pull_projects
    cleanup_project(DOCS_PROJECT_PATH)
    cleanup_project(TEAMLAB_PROJECT_PATH)

    render body: nil
  end

  def branches
    tm_branches = get_list_branches(TEAMLAB_PROJECT_PATH)
    tm_tags = get_tags(TEAMLAB_PROJECT_PATH)
    doc_branches = get_list_branches(DOCS_PROJECT_PATH)
    doc_tags = get_tags(DOCS_PROJECT_PATH)
    respond_to do |format|
      format.json do
        render json: {
          tm_branches: tm_branches,
          tm_tags: tm_tags,
          doc_branches: doc_branches,
          doc_tags: doc_tags
        }.to_json
      end
      format.html
    end
  end

  def change_branch
    branch = params['branch']
    project = params['project'].to_sym
    if project == :docs
      change_project_branch(DOCS_PROJECT_PATH, branch)
    elsif project == :teamlab
      change_project_branch(TEAMLAB_PROJECT_PATH, branch)
    end

    render body: nil
  end

  def show_servers
    @servers = Runner::Application.config.threads.all_servers_from_threads

    render layout: false
  end

  def show_tests
    render layout: false
  end

  def show_subtests
    @file_path = params['filePath']

    render layout: false
  end

  def save_list
    test_list_hash = params['test_list']
    branch = params['branch']
    project = params['project']

    test_list_name = test_list_hash['name']

    if @client.nil?
      render layout: false
      return
    end

    old_test_list = @client.test_lists.find_by_name(test_list_name)
    delete_testlist_by_id(old_test_list.id) if old_test_list

    @test_list = TestList.new(name: test_list_name)
    @test_list.client = @client
    @test_list.branch = branch
    @test_list.project = project
    if @test_list.save

      test_files_hash = test_list_hash['file_tests']

      test_files_hash.each do |_number, test_file_hash|
        test_file = TestFile.new(name: test_file_hash['file_name'])
        test_file.test_list = @test_list
        if test_file.save
          next unless test_file_hash['strokes']
          test_file_hash['strokes'].each do |_number, stroke_hash|
            stroke = Stroke.new(name: stroke_hash['name'], number: stroke_hash['number'])
            stroke.test_file = test_file
            if stroke.save
              'success'
            else
              puts stroke.errors.full_messages
            end
          end
        else
          puts test_file.errors.full_messages
        end
      end
    end

    render layout: false
  end

  def load_test_list
    list_name = params['listName']

    @test_list = @client.test_lists.find_by_name(list_name)

    respond_to do |format|
      format.json do
        render json: {
          project: @test_list.project,
          branch: @test_list.branch,
          html: render_to_string(template: 'runner/load_test_list', layout: false)
        }.to_json
      end
      format.html
    end

    # render json: {
    #    'html' => render_to_string(partial: 'load_test_list', :formats => [:html], :handlers=>[:erb], :layout => false, locals: {test_list: @test_list}),
    #    'project' => 'docs'
    # }
  end

  def updated_data
    servers = params['servers']
    servers ||= []

    client = @client

    output_json = {}
    server_data = []

    servers.each do |server|
      next unless server.is_a?(String)
      server_thread = Runner::Application.config.threads.get_thread_by_name(server)
      next unless server_thread
      server_data << server_thread.get_info_from_server(client)
    end

    manager = Runner::Application.config.run_manager.find_manager_by_client_login(client.login)

    output_json[:servers_data] = server_data
    output_json[:queue_data] = {}
    output_json[:queue_data][:servers] = manager.booked_servers
    output_json[:queue_data][:tests] = manager.tests

    output_json = output_json.to_json

    respond_to do |format|
      format.html { render json: output_json }
      format.json { render json: output_json }
    end
  end

  def rerun_thread
    Runner::Application.config.threads.get_thread_by_name(params['server']).rerun_thread

    render body: nil
  end

  def stop_current
    server = params['server']

    Runner::Application.config.threads.get_thread_by_name(server).stop_test

    render body: nil
  end

  def stop_all_booked
    Runner::Application.config.threads.get_threads_by_user(current_client).each(&:stop_test)

    render body: nil
  end

  def destroy_all_unbooked_servers
    Runner::Application.config.threads.destroy_unbooked_servers

    render body: nil
  end
end
