class SupportMailbox < ApplicationMailbox

  def process
    organisation_id = nil
    from_email = mail.from_address.to_s.split('<').last.split('>').first
    
    if user = User.adhérent.find_by(email: from_email)
      organisation_id = user.organisation_id
    else
      # Organisation.all.each do |organisation|
      #   if mail.subject.include?(organisation.numero)
      #     organisation_id = organisation.id
      #   end
      # end
    end

    if organisation_id
      organisation = Organisation.find(organisation_id)
      organisation.interventions.create( 
                      adherent_id: user.try(:id), 
                      description: "[MAIL] #{mail.subject.gsub(organisation.numero, '')}", 
                      commentaires: "De #{mail.from_address} : #{sanitize(mail.body.split('UTF-8').last.split('Content-Type').first.split('--').first)}",
                      user_id: user.try(:id)
                    )
    end
  end

end