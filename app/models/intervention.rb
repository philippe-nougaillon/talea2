class Intervention < ApplicationRecord
  include Workflow
  include WorkflowActiverecord

  acts_as_taggable_on :tags

  belongs_to :organisation
  belongs_to :agent, class_name: :User, foreign_key: :agent_id, optional: true 
  belongs_to :agent_binome, class_name: :User, foreign_key: :agent_binome_id, optional: true 
  belongs_to :adherent, class_name: :User, foreign_key: :adherent_id, optional: true 


  # WORKFLOW

  NOUVEAU = 'nouveau'
  ACCEPTE  = 'accepté'
  EN_COURS= 'en cours'
  REALISE= 'réalisé'
  VALIDE  = 'validé'
  ARCHIVE = 'archivé'

  workflow do
    state NOUVEAU, meta: {style: 'badge-info'} do
      event :accepter, transitions_to: ACCEPTE
    end

    state ACCEPTE, meta: {style: 'badge-primary'} do
      event :en_cours, transitions_to: EN_COURS
    end

    state EN_COURS, meta: {style: 'badge-warning'} do
      event :realiser, transitions_to: REALISE
    end

    state REALISE, meta: {style: 'badge-success'} do
      event :valider, transitions_to: VALIDE
    end

    state VALIDE, meta: {style: 'badge-success'} do
      event :archiver, transitions_to: ARCHIVE
    end

    state ARCHIVE, meta: {style: 'badge-dark'}
  end
end
