# frozen_string_literal: true

class SendEmailsJob < ApplicationJob
  queue_as :default

  def perform(user)
    UserMailer.welcome_email(user).deliver
  end
end
