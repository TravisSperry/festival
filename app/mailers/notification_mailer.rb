class NotificationMailer < ApplicationMailer
  def registration_confirmation(registration)
    @registration = registration
    mail(
      to: @registration.email,
      subject: "2017 Julia Robinson Mathmatics Registration Confirmation"
    )
  end
end
