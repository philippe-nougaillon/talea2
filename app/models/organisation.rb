class Organisation < ApplicationRecord
  audited

  has_many :users
  has_many :interventions
end
