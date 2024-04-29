class NotifAgentsCommentairesChangedJob < ApplicationJob
  queue_as :default

  def perform(intervention, agent_emails, user_id)
    mailer_response = NotificationMailer.commentaires_changed(intervention, agent_emails).deliver_now
    MailLog.create(organisation_id: intervention.organisation_id, user_id: user_id, message_id: mailer_response.message_id, to: agent_emails, subject: "Nouveau commentaire")
  end
end
