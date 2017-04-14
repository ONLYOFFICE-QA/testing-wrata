class ClientTestQueue
  attr_accessor :tests

  # * param tests - array of tests
  def initialize(tests = [])
    @tests = tests
    @id = 0
  end

  def push_test(test_path, branch, location, spec_language: 'en-us', to_begin_of_queue: true)
    test_name = get_name_from_path(test_path)
    test_project = get_project(test_path)
    doc_branch, tm_branch = branches(test_project, branch, location.split(' ')[0])
    data_to_push = { test_path: reformat_path(test_path),
                     id: @id,
                     doc_branch: doc_branch,
                     tm_branch: tm_branch,
                     location: location,
                     test_name: test_name,
                     project: test_project,
                     spec_language: spec_language }
    if to_begin_of_queue
      @tests.unshift(data_to_push)
    else
      @tests << data_to_push
    end
    @id += 1
  end

  def reformat_path(test_path)
    test_path.include?(HOME_DIRECTORY) ? test_path.gsub(HOME_DIRECTORY, '~') : test_path
  end

  def push_test_with_branches(test_path, tm_branch, doc_branch, location)
    test_name = get_name_from_path(test_path)
    test_project = get_project(test_path)
    @tests.unshift(test_path: test_path, id: @id, doc_branch: doc_branch, tm_branch: tm_branch,
                   location: location, test_name: test_name, project: test_project)
    @id += 1
  end

  def empty?
    @tests.empty?
  end

  def shift_test
    @tests.shift
  end

  def delete_test(test_id)
    test = @tests.find { |cur_test| cur_test[:id] == test_id }
    @tests.delete(test)
  end

  def swap_tests(test_id1, test_id2, in_start)
    test1 = @tests.find { |test| test[:id] == test_id1 }
    test1_index = @tests.index(test1)
    if in_start == 'true'
      elem = @tests.delete_at(test1_index)
      @tests.insert(0, elem)
    else
      test2 = @tests.find { |test| test[:id] == test_id2 }
      test2_index = @tests.index(test2)
      elem = @tests.delete_at(test1_index)
      @tests.insert(test2_index, elem)
    end
  end

  def change_test_location(test_id, new_location)
    test = @tests.find { |cur_test| cur_test[:id] == test_id }
    test[:location] = new_location
  end

  def clear
    @tests.clear
  end

  def shuffle
    @tests.shuffle!
  end

  def remove_duplicates
    @tests.uniq! do |current_test|
      current_test.except(:id)
    end
  end

  def get_name_from_path(test_path)
    test_path[(test_path.rindex('/') + 1)..-1]
  end

  def get_project(test_path)
    test_path.include?(DOCS_PROJECT_NAME) ? DOCS_TAB_NAME : TEAMLAB_TAB_NAME
  end

  def branches(project, branch, region)
    teamlab_branch = TEAMLAB_DEFAULT_BRANCH
    doc_branch = DOCS_DEFAULT_BRANCH
    if project == DOCS_TAB_NAME
      doc_branch = branch
      if region == INFO_SERVER
        teamlab_branch = TEAMLAB_INFO_MAIN_BRANCH
      elsif region == COM_SERVER
        teamlab_branch = TEAMLAB_COM_MAIN_BRANCH
      end
    end
    teamlab_branch = branch if project == TEAMLAB_TAB_NAME
    [doc_branch, teamlab_branch]
  end
end
