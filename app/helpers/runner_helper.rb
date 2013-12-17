module RunnerHelper

  def get_user_status
    rand(3)
  end

  def directory_hash(path, name=nil)
    data = {:data => (name || path)}
    data[:children] = children = []
    data[:path] = path
    Dir.foreach(path).sort.each do |entry|
      next if (entry == '..' || entry == '.')
      full_path = File.join(path, entry)
      if File.directory?(full_path)
        children << directory_hash(full_path, entry)
      else
        children << {:name => entry, :path => full_path}
      end
    end
    data
  end

  def get_subtest_by_path(path_to_test)
    test_file = File.new(path_to_test)
    file_tests = []
    test_file.each_with_index do |line, index|
      if line =~ /it [\'\"](.*)?[\'\"] do/
        test_name = line.scan /it [\'\"](.*?)[\'\"] do/
        file_tests << {:name =>  test_name.first.first, :stroke => (index + 1) }
      end
    end
    test_file.close
    file_tests
  end

  def get_file_path(file_name, project)
    project_path = if project == :docs
                     DOCS_TESTS_PATH
                   elsif project == :tm
                     TEAMLAB_TESTS_PATH
                   end
    path_to_test = ''
    Find.find(project_path) do |path|
      path_to_test = path if path =~ /#{file_name}/
    end
    path_to_test.gsub(project_path, '')
  end

  def get_list_branches(project_path)
    system_message = `cd #{project_path}; git pull; git checkout develop; git branch -a`
    branches = []
    system_message.to_s.gsub!('* ', '')
    system_message.to_s.split("\n  ").each do |line|
      branches << line.to_s.split(" ")
    end
    branches.flatten!
    branches.delete '->'
    branches_name = []
    branches.each do |branch|
      if branch.include?('/') && branch.include?('remote')
        branches_name << branch.gsub('remotes/origin/', '')
        next
      end
    end
    branches_name.delete 'develop'
    branches_name.unshift 'develop'
    branches_name
  end

end