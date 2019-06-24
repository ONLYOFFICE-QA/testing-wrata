# frozen_string_literal: true

class TestResultMailer < ApplicationMailer
  def spec_failed_email(history)
    @history = history
    mail(to: Rails.application.secrets.admin_email, subject: 'Something wrong happened with test')
  end
end
