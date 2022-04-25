# frozen_string_literal: true

require 'find'

class RunnerController < ApplicationController
  include GitHelper

  def index
    @controller = :runner
  end

  def branches
    branches = get_list_branches(params['project'])
    tags = get_tags(params['project'])
    respond_to do |format|
      format.json do
        render json: {
          branches: branches,
          tags: tags
        }.to_json
      end
      format.html
    end
  end

  def file_tree
    project = params['project']
    refs = params['refs']
    flatten = params['flatten'] || false

    file_tree = if flatten
                  Rails.application.config.github_helper.file_list(project, refs: refs)
                else
                  Rails.application.config.github_helper.file_tree(project, refs: refs)
                end
    render plain: file_tree.to_json
  rescue StandardError => e
    Rails.logger.error("Cannot get file_tree because #{e}")

    render plain: { name: '', children: [] }.to_json
  end

  def show_servers
    @servers = Runner::Application.config.threads&.all_servers_from_threads || []

    render layout: false
  end

  def show_tests
    render layout: false
  end

  def save_list
    test_list_hash = params['test_list']
    branch = params['branch']
    project = params['project']

    test_list_name = test_list_hash['name']

    if current_client.nil?
      render layout: false
      return
    end

    old_test_list = current_client.test_lists.find_by(name: test_list_name)
    delete_testlist_by_id(old_test_list.id) if old_test_list

    @test_list = TestList.new(name: test_list_name)
    @test_list.client = current_client
    @test_list.branch = branch
    @test_list.project = project
    if @test_list.save

      test_files_hash = test_list_hash['file_tests']

      test_files_hash.each_value do |test_file_hash|
        test_file = TestFile.new(name: test_file_hash['file_name'])
        test_file.test_list = @test_list
        Rails.logger.error(test_file.errors.full_messages) unless test_file.save
      end
    end

    render layout: false
  end

  def load_test_list
    list_name = params['listName']

    @test_list = current_client.test_lists.find_by(name: list_name)

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
  end

  def updated_data
    servers_json = params['servers']
    servers_json ||= '[]'
    servers = JSON.parse(servers_json)

    output_json = {}

    manager = Runner::Application.config.run_manager&.find_manager_by_client_login(current_client.login)

    output_json[:servers_data] = fill_server_data(servers)
    output_json[:queue_data] = {}
    output_json[:queue_data][:servers] = manager&.booked_servers || []
    output_json[:queue_data][:tests] = manager&.tests || []

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

  private

  # @param servers [Array<String>] list of servers to get data
  # @return [Array<Hash>] data about servers
  def fill_server_data(servers)
    server_data = []
    servers.each do |server|
      next unless server['name'].is_a?(String)

      server_thread = Runner::Application.config.threads.get_thread_by_name(server['name'])
      next unless server_thread

      server_data << server_thread.get_info_from_server(current_client, with_log: server['with_log'])
    end

    server_data
  end
end
