class NotificationMailer < ApplicationMailer

  def workflow_changed(intervention)
    @intervention = intervention
    manager_emails = @intervention.organisation.users.manager.pluck(:email)

    mail(to: manager_emails, subject: "[TALEA] Changement de statut")
  end
end
