class NotificationMailer < ApplicationMailer

  def workflow_changed(intervention, emails)
    @intervention = intervention

    if emails
      mail(to: emails,
          bcc: 'philippe.nougaillon@gmail.com, pierreemmanuel.dacquet@gmail.com',
          subject: "[TALEA] Changement de statut")
    end
  end
end
