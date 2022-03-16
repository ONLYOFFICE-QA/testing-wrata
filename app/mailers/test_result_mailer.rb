# frozen_string_literal: true

class TestResultMailer < ApplicationMailer
  def spec_failed_email(history)
    @history = history
    mail(to: Rails.application.credentials.admin_email, subject: t(:mailer_something_wrong_with_test_title))
  end

  def spec_no_tests_executed_email(history)
    @history = history
    mail(to: Rails.application.credentials.admin_email, subject: t(:mailer_not_a_single_test_title))
  end
end
