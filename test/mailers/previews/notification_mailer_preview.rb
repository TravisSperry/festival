# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  def registration_confirmation
    NotificationMailer.registration_confirmation(Registration.first)
  end
end
