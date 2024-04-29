class NotifManagersWorkflowChangedJob < ApplicationJob
  queue_as :default

  def perform(intervention, manager_emails, user_id)
    mailer_response = NotificationMailer.workflow_changed(intervention, manager_emails).deliver_now
    MailLog.create(organisation_id: intervention.organisation_id, user_id: user_id, message_id: mailer_response.message_id, to: manager_emails, subject: "Changement de statut")
  end
end
