module ServersHelper

  def slice_file_name(file_name)
    if file_name.include?('/')
      file_name.slice! "#{ENV['HOME']}/RubymineProjects/"
    end
    file_name[1..-1]
  end

  #def get_user_log(user_name)
  #  user_thread = $threads.get_thread_by_name(user_name).get_log
  #end
  #
  def test_fail?(total_result)
    if total_result.nil?
      true
    else
      if total_result.include? SUCCESS_TEST_STR
        false
      else
        true
      end
    end
  end

  def test_result(total_result)
    if test_fail?(total_result)
      'fail'
    else
      'success'
    end
  end

  def get_test_result(log)
    result = ''
    if log.class == String
      result = log.match /[0-9]{1,} example.+[0-9]{1,} failure.{0,}/
      result.to_s
    end
    result
  end

end
