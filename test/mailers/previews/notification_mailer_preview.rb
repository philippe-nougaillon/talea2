# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview

  def commentaire_changed
    NotificationMailer.commentaire_changed(Intervention.last)
  end

end
