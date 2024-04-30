class User < ApplicationRecord
  audited

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :rememberable, :timeoutable, :registerable and :omniauthable
  devise :database_authenticatable,
         :recoverable,
         :validatable,
         :trackable

  belongs_to :organisation, optional: true

  normalizes :nom,    with: -> nom { nom.humanize.strip }
  normalizes :prénom, with: -> prénom { prénom.humanize.strip }


  enum rôle: {
    adhérent: 0,
    agent: 1,
    manager: 2
  }

  enum service: {
    technique: 0,
    comptabilité: 1,
    informatique: 2
  }

  def self.grouped_agents(users)
    h = {}
    User.services.keys.each do |key|
      h[key.humanize] = users.agent.where(service: key).order(:nom).pluck(:nom, :id)
    end
    return h
  end

  def nom_prénom
    "#{self.nom} #{self.prénom}"
  end

  def super_admin?
    %w[philippe.nougaillon@gmail.com contact@philnoug.com pierreemmanuel.dacquet@gmail.com].include?(self.email)
  end
end
