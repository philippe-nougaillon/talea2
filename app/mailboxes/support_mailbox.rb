class SupportMailbox < ApplicationMailbox

  def process
    raise
    organisation_id = nil
    from_email = mail.from_address.to_s.split('<').last.split('>').first
    puts "email : #{from_email}"
    puts 'avant check adhérent/manager'
    # Chercher si l'envoyeur est un adhérent ou un manager
    if user = User.where(rôle: [0,2]).find_by(email: from_email)
      puts 'pendant check adhérent/manager'
      organisation_id = user.organisation_id
      puts "organisation_id : #{organisation_id}"
    else
      # Organisation.all.each do |organisation|
      #   if mail.subject.include?(organisation.numero)
      #     organisation_id = organisation.id
      #   end
      # end
    end
    puts 'après check adhérent/manager et avant check organisation_id'

    if organisation_id
      puts 'pendant check organisation_id'
      organisation = Organisation.find(organisation_id)
      puts "organisation : #{organisation.inspect}"
      organisation.interventions.create( 
                      adherent_id: user.try(:id), 
                      description: "[MAIL] #{mail.subject.gsub(organisation.numero, '')}", 
                      commentaires: "De #{mail.from_address} : #{mail.body}",
                      user_id: user.try(:id)
                    )
        puts 'après création intervention'
    end
    puts 'après check organisation_id'
  end

end