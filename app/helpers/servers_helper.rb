module ServersHelper
  def test_fail?(total_result)
    if total_result.nil?
      true
    elsif total_result.include? SUCCESS_TEST_STR
      false
    else
      true
    end
  end

  def test_result(total_result)
    if test_fail?(total_result)
      'danger'
    else
      'success'
    end
  end
end
