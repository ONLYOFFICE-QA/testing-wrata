# frozen_string_literal: true

class ClientTestQueue
  attr_accessor :tests

  # * param tests - array of tests
  def initialize(tests = [])
    @tests = tests
    @id = 0
  end

  def push_test(test_path, branch, location, params = {})
    test_name = get_name_from_path(test_path)
    test_project = get_project(test_path)
    if params[:doc_branch].nil? || params[:tm_branch].nil?
      params[:doc_branch] = branch
      params[:tm_branch] = branch
    end
    data_to_push = { test_path:,
                     id: @id,
                     doc_branch: params[:doc_branch],
                     tm_branch: params[:tm_branch],
                     location:,
                     test_name:,
                     project: test_project,
                     spec_browser: params.fetch(:spec_browser, SpecBrowser::DEFAULT),
                     spec_language: params.fetch(:spec_language, 'en-us') }
    if params.fetch(:to_begin_of_queue, true)
      @tests.unshift(data_to_push)
    else
      @tests << data_to_push
    end
    @id += 1
  end

  delegate :empty?, to: :@tests

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

  delegate :clear, to: :@tests

  def shuffle
    @tests.shuffle!
  end

  def remove_duplicates
    @tests.uniq! do |current_test|
      current_test.except(:id)
    end
  end

  def get_name_from_path(test_path)
    test_path[(test_path.rindex('/') + 1)..]
  end

  def get_project(test_path)
    test_path.include?(DOCS_PROJECT_NAME) ? DOCS_TAB_NAME : TEAMLAB_TAB_NAME
  end

  def branches(project, branch, region)
    teamlab_branch = 'develop'
    doc_branch = 'develop'
    if project == DOCS_TAB_NAME
      doc_branch = branch
      case region
      when 'info'
        teamlab_branch = 'develop'
      when 'com'
        teamlab_branch = 'master'
      end
    end
    teamlab_branch = branch if project == TEAMLAB_TAB_NAME
    [doc_branch, teamlab_branch]
  end
end
