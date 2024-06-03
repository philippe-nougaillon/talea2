class NotificationMailer < ApplicationMailer

  def workflow_changed(intervention, emails)
    @intervention = intervention

    mail(to: emails,
        bcc: 'philippe.nougaillon@gmail.com, pierreemmanuel.dacquet@gmail.com',
        subject: "[TALEA] Changement de statut").tap do |message|
      message.mailgun_options = {
        "tag" => ["changement de statut"]
      }
    end
  end

  def commentaires_changed(intervention, emails)
    @intervention = intervention

    mail(to: emails,
          bcc: 'philippe.nougaillon@gmail.com, pierreemmanuel.dacquet@gmail.com',
          subject: "[TALEA] Nouveau commentaire").tap do |message|
      message.mailgun_options = {
        "tag" => ["nouveau commentaire"]
      }
    end
  end

  def relance(intervention)
    @intervention = intervention

    mail(to: intervention.adherent.email,
          bcc: 'philippe.nougaillon@gmail.com, pierreemmanuel.dacquet@gmail.com',
          subject: "[TALEA] Relance. Intervention à valider").tap do |message|
      message.mailgun_options = {
        "tag" => ["relance"]
      }
    end
  end

  def welcome(user)
    @user = user
    mail(to: @user.email, subject: '[TALEA] Bienvenue !')
  end

  def new_organisation(organisation)
    @organisation = organisation
    mail(to: 'philippe.nougaillon@gmail.com, pierreemmanuel.dacquet@gmail.com', subject: '[TALEA] Nouvelle Organisation')
  end

end
