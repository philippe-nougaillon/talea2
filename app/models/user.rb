class User < ApplicationRecord
  audited

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :registerable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :validatable

  belongs_to :organisation, optional: true

  normalizes :nom, with: -> nom { nom.humanize.strip }
  normalizes :prénom, with: -> prénom { prénom.humanize.strip }

  enum rôle: {
    adhérent: 0,
    agent: 1,
    manager: 2
  }

  def interventions_by_role
    case self.rôle
    when 'manager'
      self.organisation.interventions
    when 'adhérent'
      self.organisation.interventions.where(adherent_id: self.id)
    when 'agent'
      self.organisation.interventions.where("agent_id = :id OR agent_binome_id = :id", {id: self.id})
    end
  end

  def nom_prénom
    "#{self.nom} #{self.prénom}"
  end
end
