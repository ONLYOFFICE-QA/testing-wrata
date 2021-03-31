# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.failure_notification_username
  layout 'mailer'
end
