class NotificationMailer < ApplicationMailer

  def workflow_changed(intervention, user_id)
    @intervention = intervention
    manager_emails = @intervention.organisation.users.where.not(id: user_id).manager.pluck(:email)

    if manager_emails.any?
      mail(to: manager_emails, bcc: 'philippe.nougaillon@gmail.com, pierreemmanuel.dacquet@gmail.com', subject: "[TALEA] Changement de statut")
    end
  end
end
