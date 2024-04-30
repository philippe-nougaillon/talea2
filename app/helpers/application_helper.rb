module ApplicationHelper
  include Pagy::Frontend

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
            pretty_changes << "#{key} changé de '#{User.find_by(id: ids.first).try(:nom_prénom) || "#{ids.first} (Utilisateur supprimé)" if ids.first}' à '#{User.find_by(id: ids.last).try(:nom_prénom) || "#{ids.last} (Utilisateur supprimé)" if ids.last}'"
          end 
        else
          case ids.class.name
          when 'NilClass'
            pretty_changes << "#{key} initialisé à vide"
          when 'Array'
            pretty_changes << "#{key} changé de '#{ids.first}' à '#{ids.last}' (Utilisateurs supprimés)"
          when 'Integer'
            pretty_changes << "#{key} initialisé à '#{ids}' (Utilisateur supprimé)"
          end
        end
      when 'Workflow state'
        if audit.action == 'update'
          unless c.last.first.blank? && c.last.last.blank?    
            pretty_changes << "Statut modifié de '#{c.last.first.humanize}' à '#{c.last.last.humanize}'"
          end
        else 
          unless c.last.blank?
            pretty_changes << "Statut #{audit.action == 'create' ? 'initialisé à' : 'était'} '#{c.last.humanize}'"
          end
        end
      when 'Rôle'
        rôles = User.rôles.invert
        if audit.action == 'update'
          unless c.last.first.blank? && c.last.last.blank?    
            pretty_changes << "#{key} modifié de '#{rôles[c.last.first].humanize}' à '#{rôles[c.last.last].humanize}'"
          end
        else 
          unless c.last.blank?
            pretty_changes << "#{key} #{audit.action == 'create' ? 'initialisé à' : 'était'} '#{rôles[c.last].humanize}'"
          end
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

  def audited_view_path(audit)
    case audit.auditable_type
    when "Intervention"
      if Intervention.exists?(audit.auditable_id)
        intervention_path(audit.auditable_id)
      end
    when "User"
      if User.exists?(audit.auditable_id)
        user_path(audit.auditable_id)
      end
    end
  end

end
