class InterventionsToXls < ApplicationService
  require 'spreadsheet'
  attr_reader :interventions
  private :interventions

  def initialize(interventions)
    @interventions = interventions
  end

  def call
    Spreadsheet.client_encoding = 'UTF-8'
  
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet name: @interventions.name
    bold = Spreadsheet::Format.new :weight => :bold, :size => 11

    headers = %w{id description tags statut adhérent agent agent_binome début fin temps_de_pause temps_total commentaires créé_le modifiée_le}

    sheet.row(0).concat headers
    sheet.row(0).default_format = bold
    
    index = 1

    @interventions.each do |intervention|
      fields_to_export = [
        intervention.id,
        intervention.description,
        intervention.tag_list.join(', '),
        intervention.workflow_state.humanize,
        intervention.adherent.try(:nom_prénom),
        intervention.agent.try(:nom_prénom),
        intervention.agent_binome.try(:nom_prénom),
        intervention.début ? I18n.l(intervention.début) : "",
        intervention.fin ? I18n.l(intervention.fin) : "",
        intervention.temps_de_pause,
        intervention.temps_total,
        intervention.commentaires,
        I18n.l(intervention.created_at),
        I18n.l(intervention.updated_at),
      ]
      sheet.row(index).replace fields_to_export
      index += 1
    end
    return book

  end

end