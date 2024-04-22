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

  def nom_prénom
    "#{self.nom} #{self.prénom}"
  end
end
