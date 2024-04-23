module ApplicationHelper

  def prettify(audit)
    pretty_changes = []

    audit.audited_changes.each do |c|
      key = c.first.humanize
      case key
      when 'User', 'Agent', 'Adherent', 'Agent binome'
        ids = audit.audited_changes["#{key == "Agent binome" ? key.humanize.downcase.tr(' ', '_') : key.downcase}_id"]
        if User.exists?(id: ids)
          case ids.class.name
          when 'Integer'
            pretty_changes << "#{key} initialisé à '#{User.find(ids).nom_prénom}'"
          when 'Array'
            pretty_changes << "#{key} changé de '#{User.find(ids.first).nom_prénom if ids.first}' à '#{User.find(ids.last).nom_prénom if ids.last}'"
          end 
        else
          pretty_changes << "#{key} supprimé"
        end
      else
        if audit.action == 'update'
          unless c.last.first.blank? && c.last.last.blank?    
            pretty_changes << "#{key} modifié de '#{c.last.first}' à '#{c.last.last}'"
          end
        else 
          unless c.last.blank?
            pretty_changes << "#{key} #{audit.action == 'create' ? 'initialisé à' : 'était'} '#{c.last}'"
          end
        end
      end
    end
    pretty_changes
  end

end
