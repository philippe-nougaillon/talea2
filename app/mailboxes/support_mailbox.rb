class SupportMailbox < ApplicationMailbox

  def process
    organisation_id = nil

    if user = User.find_by(email: mail.from_address.to_s)
      organisation_id = user.organisation_id
    else
      Organisation.all.each do |organisation|
        if mail.subject.include?(organisation.numero)
          organisation_id = organisation.id
        end
      end
    end

    if organisation_id
      Intervention.create(organisation_id: organisation_id, adherent_id: user.try(:id), description: "[SUPPORT] #{mail.subject}", commentaires: "De #{mail.from_address} : #{mail.content}")
    end
  end

end