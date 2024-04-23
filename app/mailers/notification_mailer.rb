class NotificationMailer < ApplicationMailer

  def workflow_changed(intervention, emails)
    @intervention = intervention

    if emails
      mail(to: emails,
          bcc: 'philippe.nougaillon@gmail.com, pierreemmanuel.dacquet@gmail.com',
          subject: "[TALEA] Changement de statut")
    end
  end

  def commentaires_changed(intervention)
    @intervention = intervention
    agent_emails = [Intervention.last.agent.email, Intervention.last.agent_binome.try(:email)].join(',')

    mail(to: agent_emails,
          bcc: 'philippe.nougaillon@gmail.com, pierreemmanuel.dacquet@gmail.com',
          subject: "[TALEA] Nouveau commentaire")
  end
end
