class InterventionsController < ApplicationController
  before_action :set_intervention, only: %i[ show edit update destroy accepter en_cours realiser valider archiver ]

  # GET /interventions or /interventions.json
  def index
    @interventions = current_user.organisation.interventions
  end

  # GET /interventions/1 or /interventions/1.json
  def show
  end

  # GET /interventions/new
  def new
    @intervention = Intervention.new
  end

  # GET /interventions/1/edit
  def edit
  end

  # POST /interventions or /interventions.json
  def create
    @intervention = Intervention.new(intervention_params)
    @intervention.organisation = current_user.organisation

    respond_to do |format|
      if @intervention.save
        format.html { redirect_to intervention_url(@intervention), notice: "Intervention was successfully created." }
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
        format.html { redirect_to intervention_url(@intervention), notice: "Intervention was successfully updated." }
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
      format.html { redirect_to interventions_url, notice: "Intervention was successfully destroyed." }
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

  def realiser
    @intervention.realiser!
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
      params.require(:intervention).permit(:organisation_id, :agent_id, :agent_binome_id, :adherent_id, :début, :fin, :temps_de_pause, :description, :workflow_state, :tag_list)
    end
end
