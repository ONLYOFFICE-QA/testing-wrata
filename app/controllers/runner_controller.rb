require 'find'
require_relative '../../../SharedFunctional/RunnerHelper/TestrailRunnerHelper'

class RunnerController < ApplicationController

  STATUS_ONLINE = 0
  STATUS_OFFLINE = 1
  STATUS_WAIT = 2

  def index
    unless current_client
      redirect_to signin_path
    end
  end

  def change_branch
    branch =  params['branch']
    project =  params['project'].to_sym
    if project == :docs
      `cd #{DOCS_PROJECT_PATH}; git checkout #{branch}; git pull;`
    elsif  project == :teamlab
      `cd #{TEAMLAB_PROJECT_PATH}; git checkout #{branch}; git pull;`
    end

    render :nothing => true
  end

  def show_servers
    @servers = $threads.get_all_servers_from_threads

    render :layout => false
  end

  def show_tests
    @client = current_client

    render :layout => false
  end

  def get_status
    json = []
    @servers = $threads.get_all_servers_from_threads
    @servers.each do |server|
      json << {
          :name => server.name.downcase,
          :status => rand(3)
      }
    end
    respond_to do |format|
      format.json { render :json => json.to_json }
    end
  end

  def get_client_name(client)
    if current_client
      client.login
    else
      GUEST_NAME
    end
  end

  def start

    doc_branch, teamlab_branch = view_context.get_branches(params['project'], params['branch'], params['server'])

    start_command = []
    client = current_client

    amazon_options = view_context.
        make_start_options_command(doc_branch, teamlab_branch, params['region'], params['server'])
    options = ServerOptions.new(doc_branch, teamlab_branch, params['server'], params['region'])

    tests = params['selectedTests']
    servers = params['selectedServers']

    i = 0

    while i <= tests.size
      servers.each_with_index do |server, index|
        index = index + i
        if tests[index]
          if server == AMAZON_SERVER_NAME
            start_command << view_context.make_start_list(tests[index], amazon_options)
          else
            $threads.get_thread_by_name(server).add_to_queue(view_context.edit_file_path(tests[index]), options, client)
          end
        end
      end
      i += servers.size
    end

    respond_to do |format|
      format.json { render :json => {start_command: start_command,
                                     options: options
                                    }.to_json }
    end
  end

  def start_list

    doc_branch, teamlab_branch = view_context.get_branches(params['project'], params['branch'], params['server'])

    start_command = []
    client = current_client

    amazon_options = view_context.
        make_start_options_command(doc_branch, teamlab_branch, params['region'], params['server'])
    options = ServerOptions.new(doc_branch, teamlab_branch, params['server'], params['region'])

    servers = params['selectedServers']
    tests = params['testList']['file_tests']

    i = 0

    while i <= tests.size
      servers.each_with_index do |server, index|
        index = (index + i).to_s      #FUCK IT JSON FROM JS
        if tests[index]
          if tests[index].has_key?('strokes')
            if server == AMAZON_SERVER_NAME
              start_command << view_context.
                  make_start_list_with_stroke(tests[index]['file_name'], tests[index]['strokes'], amazon_options)
            else
              $threads.
                  get_thread_by_name(server).
                  add_to_queue(view_context.
                                   create_path_with_stoke_local(tests[index]['file_name'], tests[index]['strokes']), options, client)
            end

          else
            if server == AMAZON_SERVER_NAME
              start_command << view_context.make_start_list(tests[index]['file_name'], amazon_options)
            else
              $threads.get_thread_by_name(server).
                  add_to_queue(view_context.edit_file_path(tests[index]['file_name']), options, client)
            end

          end
        end
      end
      i += servers.size
    end

    respond_to do |format|
      format.json { render :json => {
                                     start_command: start_command,
                                     options: options,}.to_json }
    end

  end

  def show_subtests
    @file_path = params['filePath']

    render :layout => false
  end

  def save_list
    test_list_hash = params['test_list']
    branch = params['branch']
    project =  params['project']

    test_list_name = test_list_hash['name']

    if current_client.nil?
      render :layout => false
      return
    end

    old_test_list = current_client.test_lists.find_by_name(test_list_name)
    delete_testlist_by_id(old_test_list.id) if old_test_list

    @test_list = TestList.new(name: test_list_name)
    @test_list.client = current_client
    @test_list.branch = branch
    @test_list.project = project
    if @test_list.save

      test_files_hash = test_list_hash['file_tests']

      test_files_hash.each do |number, test_file_hash|
        test_file = TestFile.new(name: test_file_hash['file_name'])
        test_file.test_list = @test_list
        if test_file.save
          if test_file_hash['strokes']
            test_file_hash['strokes'].each do |number, stroke_hash|
              stroke = Stroke.new(name: stroke_hash['name'], number: stroke_hash['number'])
              stroke.test_file = test_file
              if stroke.save
                'success'
              else
                puts stroke.errors.full_messages
              end
            end
          end
        else
          puts test_file.errors.full_messages
        end
      end
    else

    end

    render :layout => false
  end

  def load_test_list

    list_name = params['listName']

    @test_list = current_client.test_lists.find_by_name(list_name)

    respond_to do |format|
      format.json { render :json => {
          project: @test_list.project,
          branch: @test_list.branch,
          html: render_to_string(template: 'runner/load_test_list', :layout => false),
      }.to_json }
      format.html
    end

    #render json: {
    #    'html' => render_to_string(partial: 'load_test_list', :formats => [:html], :handlers=>[:erb], :layout => false, locals: {test_list: @test_list}),
    #    'project' => 'docs'
    #}
  end

  def get_info
     servers = params['servers']
     servers.delete(AMAZON_SERVER_NAME)

     output_json = []

     servers.each do |server|
       server_thread = $threads.get_thread_by_name(server)
       output_json << server_thread.get_info_from_server
     end

     output_json = output_json.to_json

     respond_to do |format|
       format.json { render :json => output_json }
     end
  end

  #def ping(server_ip)
  #  command =   "ping -w1 -c1 #{server_ip}"
  #  r, w = IO.pipe
  #  pid = spawn(command, :out => w)
  #  Process.wait pid
  #  w.close
  #  status = r.read.include?('0 received')
  #  !status
  #end

  def rerun_thread
    server = params['server']

    $threads.get_thread_by_name(server).rerun_thread

    render :nothing => true
  end

  def stop_current
    server = params['server']

    $threads.get_thread_by_name(server).stop_current

    render :nothing => true
  end

  #
  #def get_status
  #
  #end
end

