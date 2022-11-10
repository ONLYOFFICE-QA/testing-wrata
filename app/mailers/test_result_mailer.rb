# frozen_string_literal: true

class TestResultMailer < ApplicationMailer
  # This emailed will be send if test not finished properly
  # If test finished, but have some failed tests - this is not a email for him
  # But if test stopped for some reason in middle of something - it will be send
  # @param [History] history entry for which email is sent
  # @return [nil]
  def spec_failed_email(history)
    @history = history
    mail(to: Rails.application.credentials.admin_email, subject: t(:mailer_something_wrong_with_test_title))
  end

  # This email will be send if there is not a single `it`
  # excuted in single `spec`
  # @param [History] history entry for which email is sent
  # @return [nil]
  def spec_no_tests_executed_email(history)
    @history = history
    mail(to: Rails.application.credentials.admin_email, subject: t(:mailer_not_a_single_test_title))
  end
end
