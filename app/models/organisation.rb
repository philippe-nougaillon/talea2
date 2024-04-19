class Organisation < ApplicationRecord
  has_many :users
  has_many :interventions
end
