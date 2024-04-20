class InterventionsController < ApplicationController
  before_action :set_intervention, only: %i[ show edit update destroy accepter en_cours terminer valider archiver ]

  # GET /interventions or /interventions.json
  def index
    @interventions = Intervention.by_role_for(current_user)
    @tags = @interventions.tag_counts_on(:tags).order(:name)

    @adhérents = current_user.organisation.users.adhérent
    @agents = current_user.organisation.users.agent

    if params[:search].present?
      @interventions = @interventions.where("description ILIKE :search", {search: "%#{params[:search]}%"})
    end

    if params[:adherent_id].present?
      @interventions = @interventions.where(adherent_id: params[:adherent_id])
    end

    if params[:agent_id].present?
      @interventions = @interventions.where(agent_id: params[:agent_id]).or(@interventions.where(agent_binome_id: params[:agent_id]))
    end

    if params[:du].present?
      if params[:au].present?
        @interventions = @interventions.where("DATE(début) BETWEEN ? AND ?", params[:du], params[:au])
      else
        @interventions = @interventions.where("DATE(début) = ?", params[:du]).or(@interventions.where("DATE(fin) = ?", params[:du]))
      end
    elsif params[:au].present?
      @interventions = @interventions.where("DATE(fin) = ?", params[:au])
    end

    if params[:workflow_state].present?
      @interventions = @interventions.where("interventions.workflow_state = ?", params[:workflow_state].to_s.downcase)
    end

    if params[:tags].present?
      @interventions = @interventions.tagged_with(params[:tags].reject(&:blank?))
      session[:tags] = params[:tags]
    else
      session[:tags] = params[:tags] = []
    end
  end

  # GET /interventions/1 or /interventions/1.json
  def show
  end

  # GET /interventions/new
  def new
    @intervention = Intervention.new
    @agents = current_user.organisation.users.agent
    @adhérents = current_user.organisation.users.adhérent
  end

  # GET /interventions/1/edit
  def edit
    @agents = current_user.organisation.users.agent
    @adhérents = current_user.organisation.users.adhérent
  end

  # POST /interventions or /interventions.json
  def create
    @intervention = Intervention.new(intervention_params)
    @intervention.organisation = current_user.organisation

    respond_to do |format|
      if @intervention.save
        format.html { redirect_to intervention_url(@intervention), notice: "Intervention créée avec succès." }
        format.json { render :show, status: :created, location: @intervention }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @intervention.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /interventions/1 or /interventions/1.json
  def update
    respond_to do |format|
      if @intervention.update(intervention_params)
        format.html { redirect_to intervention_url(@intervention), notice: "Intervention modifiée avec succès." }
        format.json { render :show, status: :ok, location: @intervention }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @intervention.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /interventions/1 or /interventions/1.json
  def destroy
    @intervention.destroy!

    respond_to do |format|
      format.html { redirect_to interventions_url, notice: "Intervention détruite avec succès." }
      format.json { head :no_content }
    end
  end

  def accepter
    @intervention.accepter!
    redirect_to @intervention, notice: "Intervention acceptée"
  end

  def en_cours
    @intervention.en_cours!
    redirect_to @intervention, notice: "Intervention en cours"
  end

  def terminer
    @intervention.terminer!
    redirect_to @intervention, notice: "Intervention réalisée"
  end

  def valider
    @intervention.valider!
    redirect_to @intervention, notice: "Intervention validée"
  end

  def archiver
    @intervention.archiver!
    redirect_to @intervention, notice: "Intervention archivée"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_intervention
      @intervention = Intervention.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def intervention_params
      params.require(:intervention).permit(:organisation_id, :agent_id, :agent_binome_id, :adherent_id, :début, :fin, :temps_de_pause, :description, :commentaires, :workflow_state, :tag_list)
    end
end
