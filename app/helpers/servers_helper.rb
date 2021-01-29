# frozen_string_literal: true

module ServersHelper
  def test_fail?(total_result)
    total_result.exclude?(SUCCESS_TEST_STR)
  end

  def test_result(total_result)
    if test_fail?(total_result)
      'danger'
    else
      'success'
    end
  end
end
