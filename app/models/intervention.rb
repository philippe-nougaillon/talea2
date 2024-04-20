class Intervention < ApplicationRecord
  include Workflow
  include WorkflowActiverecord

  acts_as_taggable_on :tags

  audited

  belongs_to :organisation
  belongs_to :agent, class_name: :User, foreign_key: :agent_id, optional: true 
  belongs_to :agent_binome, class_name: :User, foreign_key: :agent_binome_id, optional: true 
  belongs_to :adherent, class_name: :User, foreign_key: :adherent_id, optional: true 

  before_save :calcul_temps_total

  scope :ordered, -> { order(updated_at: :desc) }

  # WORKFLOW
  NOUVEAU   = 'nouveau'
  ACCEPTE   = 'accepté'
  EN_COURS  = 'en cours'
  REALISE   = 'réalisé'
  VALIDE    = 'validé'
  ARCHIVE   = 'archivé'

  workflow do
    state NOUVEAU, meta: {style: 'badge-info text-white'} do
      event :accepter, transitions_to: ACCEPTE
    end

    state ACCEPTE, meta: {style: 'badge-primary text-white'} do
      event :en_cours, transitions_to: EN_COURS
    end

    state EN_COURS, meta: {style: 'badge-warning text-white'} do
      event :realiser, transitions_to: REALISE
    end

    state REALISE, meta: {style: 'badge-error text-white'} do
      event :valider, transitions_to: VALIDE
    end

    state VALIDE, meta: {style: 'badge-success text-white'} do
      event :archiver, transitions_to: ARCHIVE
    end

    state ARCHIVE, meta: {style: 'badge-ghost'}
  end

  # pour que le changement de 'workflow_state' se voit dans l'audit trail
  def persist_workflow_state(new_value)
    self[:workflow_state] = new_value
    save!
  end
  
  def style
    self.current_state.meta[:style]
  end

  def self.workflow_states_count(interventions)
    interventions.reorder(:workflow_state).select(:id).group(:workflow_state).count(:id)
  end

  def self.by_role_for(user)
    case user.rôle
    when 'manager'
      user.organisation.interventions.ordered
    when 'adhérent'
      user.organisation.interventions.where(adherent_id: user.id)
    when 'agent'
      user.organisation.interventions.where("agent_id = :id OR agent_binome_id = :id", {id: user.id})
    end
  end

  private

  def calcul_temps_total
    total = 0
    if self.fin && self.début
      total = ((self.fin - self.début).to_i / 3600.0) - self.temps_de_pause
    end
    self.temps_total = total
  end
  
end
