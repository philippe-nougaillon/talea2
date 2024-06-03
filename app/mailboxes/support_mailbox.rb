class SupportMailbox < ApplicationMailbox
  def process
    organisation_id = nil

    if user = User.find_by(email: mail.from_address.to_s)
      organisation_id = user.organisation_id
    else
      # organisation_id = Organisation.find_by
    end

    if organisation_id
      intervention = Intervention.create(organisation_id: organisation_id, adherent_id: user.id, description: "[SUPPORT] #{mail.subject}")
      SupportRequest.create!(email: mail.from_address.to_s, subject: mail.subject, body: mail.body.to_s, intervention: intervention)
    end
  end
end