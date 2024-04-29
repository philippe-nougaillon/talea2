class EmailSubscription

  def on_intervention_workflow_changed(event)
    intervention = Intervention.find(event[:payload][:intervention_id])
    user_id = event[:payload][:user_id]
    manager_emails = intervention.organisation.users.where.not(id: user_id).manager.pluck(:email)
    if manager_emails.any?
      NotifManagersWorkflowChangedJob.perform_later(intervention, manager_emails, user_id)
    end
  end

  def on_intervention_termine(event)
    user = User.find(event[:payload][:user_id])
    intervention = Intervention.find(event[:payload][:intervention_id])
    if user.agent? && intervention.adherent
      adherent_email = User.where(id: intervention.adherent_id).pluck(:email)
      if adherent_email.any?
        NotifAdherentInterventionTermineeJob.perform_later(intervention, adherent_email, user.id)
      end
    end
  end

  def on_intervention_commentaires_changed(event)
    user = User.find(event[:payload][:user_id])
    intervention = Intervention.find(event[:payload][:intervention_id])
    send_notif = ( user.adhérent? && (event[:payload][:old_commentaires] != intervention.commentaires) && !intervention.blank? )
    agent_emails = [intervention.agent.try(:email), intervention.agent_binome.try(:email)]
    if send_notif && agent_emails.any?
      NotifAgentsCommentairesChangedJob.perform_later(intervention, agent_emails, user.id)
    end
  end

end