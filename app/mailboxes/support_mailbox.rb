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
      organisation = Organisation.find(organisation_id)
      organisation.interventions.create( 
                      adherent_id: user.try(:id), 
                      description: "[MAIL] #{mail.subject.gsub(organisation.numero, '')}", 
                      commentaires: "De #{mail.from_address} : #{mail.content}"
                    )
    end
  end

end