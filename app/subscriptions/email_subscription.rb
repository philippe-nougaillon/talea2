class EmailSubscription

  # Notifier les managers qu'un changement de statut a eu lieu
  def on_intervention_workflow_changed(event)
    intervention = Intervention.find(event[:payload][:intervention_id])
    user_id = intervention.audits.last.user_id
    manager_emails = intervention.organisation.users.where.not(id: user_id).manager.pluck(:email)
    if manager_emails.any?
      NotifManagersWorkflowChangedJob.perform_later(intervention, manager_emails, user_id)
    end
  end

  # Notifier les adhérents qu'une intervention a été terminée par un agent
  def on_intervention_done(event)
    intervention = Intervention.find(event[:payload][:intervention_id])
    user = User.find(intervention.audits.last.user_id)
    if user.agent? && intervention.adherent
      adherent_email = User.where(id: intervention.adherent_id).pluck(:email)
      if adherent_email.any?
        NotifAdherentInterventionTermineeJob.perform_later(intervention, adherent_email, user.id)
      end
    end
  end

  # Notifier les agents qu'un commentaire a été ajouté par un adhérent
  def on_intervention_updated(event)
    intervention = Intervention.find(event[:payload][:intervention_id])
    last_audit = intervention.audits.last
    user = User.find(last_audit.user_id)
    commentaires_changed = last_audit.audited_changes.include?('commentaires')
    send_notif = (user.adhérent? && commentaires_changed && !intervention.commentaires.blank?)
    agent_emails = [intervention.agent.try(:email), intervention.agent_binome.try(:email)]
    if send_notif && agent_emails.any?
      NotifAgentsCommentairesChangedJob.perform_later(intervention, agent_emails, user.id)
    end
  end

  def on_organisation_created(event)
    user = User.find(event[:payload][:user_id])
    WelcomeNotificationJob.perform_later(user)
    NewOrganisationNotificationJob.perform_later(user.organisation)
  end

end