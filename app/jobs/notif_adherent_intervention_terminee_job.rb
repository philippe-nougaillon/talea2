class NotifAdherentInterventionTermineeJob < ApplicationJob
  queue_as :default

  def perform(intervention, adherent_email, user_id)
    mailer_response = NotificationMailer.workflow_changed(intervention, adherent_email).deliver_now
    MailLog.create(organisation_id: intervention.organisation_id, user_id: user_id, message_id: mailer_response.message_id, to: adherent_email, subject: "Intervention terminée")
  end
end
