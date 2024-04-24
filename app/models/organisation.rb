class Organisation < ApplicationRecord
  audited

  has_many :users
  has_many :interventions
  has_many :mail_logs
end
