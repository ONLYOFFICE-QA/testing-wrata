# frozen_string_literal: true

class TestResultMailer < ApplicationMailer
  def spec_failed_email(history)
    @history = history
    mail(to: Rails.application.credentials.admin_email, subject: 'Something wrong happened with test')
  end

  def spec_no_tests_executed_email(history)
    @history = history
    mail(to: Rails.application.credentials.admin_email, subject: 'There was not a single test in executed spec')
  end
end
