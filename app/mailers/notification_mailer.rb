class NotificationMailer < ApplicationMailer

  def workflow_changed(intervention, emails)
    @intervention = intervention

    mail(to: emails,
        bcc: 'philippe.nougaillon@gmail.com, pierreemmanuel.dacquet@gmail.com',
        subject: "[TALEA] Changement de statut")
  end

  def commentaires_changed(intervention, emails)
    @intervention = intervention

    mail(to: emails,
          bcc: 'philippe.nougaillon@gmail.com, pierreemmanuel.dacquet@gmail.com',
          subject: "[TALEA] Nouveau commentaire").tap do |message|
      message.mailgun_options = {
        "tag" => [emails.first, emails.last, "nouveau commentaire"]
      }
    end
  end
end
