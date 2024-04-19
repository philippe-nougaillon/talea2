class AddAdherentToIntervention < ActiveRecord::Migration[7.1]
  def change
    add_column :interventions, :adherent_id, :integer
    add_index :interventions, :adherent_id
  end
end
