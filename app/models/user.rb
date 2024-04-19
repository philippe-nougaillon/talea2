class User < ApplicationRecord
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

  def nom_prénom
    "#{self.nom} #{self.prénom}"
  end
end
