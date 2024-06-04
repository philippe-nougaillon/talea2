namespace :mail_logs do
  
  desc "Récupérer statut mail_logs"
  task :fetch, [:enregistrer] => :environment do |task, args|
    require 'dotenv/tasks'
    mg_client = Mailgun::Client.new ENV["MAILGUN_API_KEY"], 'api.eu.mailgun.net'
    domain = ENV["MAILGUN_DOMAIN"]
    result_failed = mg_client.get("#{domain}/events", {:event => 'failed'}).to_h
    result_opened = mg_client.get("#{domain}/events", {:event => 'opened'}).to_h
    
    mail_logs = MailLog.where("created_at::DATE - NOW()::DATE <= ?", 5)
    mail_logs.each do |mail_log|
      # puts "CHECK MAILOG n°#{mail_log.id}"

      # Check erreur
      if mail_log.statut && error_message = result_failed["items"].find{|item| item["message"]["headers"]["message-id"] == mail_log.message_id }
        mail_log.update!(statut: false, error_message: error_message)
        # puts "Mail_log #{mail_log.id} a une erreur : #{mail_log.error_message}"
      end

      # Check lu
      if !mail_log.etat && result_opened["items"].find{|item| item["message"]["headers"]["message-id"] == mail_log.message_id }
        mail_log.update!(etat: true)
        # puts "Mail_log #{mail_log.id} a été lu"
      end
    end

  end

end