class Intervention < ApplicationRecord
  belongs_to :organisation
  belongs_to :agent, class_name: :User, foreign_key: :agent_id, optional: true 
  belongs_to :agent_binome, class_name: :User, foreign_key: :agent_binome_id, optional: true 
  belongs_to :adherent, class_name: :User, foreign_key: :adherent_id, optional: true 
end
