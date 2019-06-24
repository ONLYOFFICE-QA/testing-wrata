# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'notifications@wrata.onlyoffice.com'
  layout 'mailer'
end
