class InterventionsController < ApplicationController
  before_action :set_intervention, only: %i[ show edit update destroy accepter en_cours terminer valider refuser archiver purge ]
  before_action :is_user_authorized

  # GET /interventions or /interventions.json
  def index
    @interventions = Intervention.by_role_for(current_user)
    @interventions_count = @interventions.count
    @organisation_members = current_user.organisation.users
    @grouped_agents = User.grouped_agents(@organisation_members)
    @tags = @interventions.tag_counts_on(:tags).order(:name)

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

    respond_to do |format|
      format.html do
        @interventions = @interventions.includes(:tags).with_attached_photos
      end

      format.xls do
        xls_file = InterventionsToXls.new(@interventions).call
        send_data xls_file, filename: "Interventions_#{DateTime.now}.xls"
      end
    end
  end

  # GET /interventions/1 or /interventions/1.json
  def show
  end

  # GET /interventions/new
  def new
    @intervention = Intervention.new
    @organisation_members = current_user.organisation.users
    @grouped_agents = User.grouped_agents(@organisation_members)
  end

  # GET /interventions/1/edit
  def edit
    @organisation_members = current_user.organisation.users
    @grouped_agents = User.grouped_agents(@organisation_members)
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
        unless Rails.env.development?
          Events.instance.publish('intervention.updated', payload: {intervention_id: @intervention.id})
        end
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
    send_workflow_changed_notification
    redirect_to @intervention, notice: "Intervention acceptée"
  end

  def en_cours
    @intervention.en_cours!
    send_workflow_changed_notification
    redirect_to @intervention, notice: "Intervention en cours"
  end

  def terminer
    @intervention.terminer!
    send_workflow_changed_notification
    send_intervention_termine_notification
    redirect_to @intervention, notice: "Intervention terminée"
  end

  def valider
    @intervention.valider!
    send_workflow_changed_notification
    redirect_to @intervention, notice: "Intervention validée"
  end

  def refuser
    @intervention.refuser!
    send_workflow_changed_notification
    redirect_to @intervention, notice: "Intervention refusée"
  end

  def archiver
    @intervention.archiver!
    send_workflow_changed_notification
    redirect_to @intervention, notice: "Intervention archivée"
  end

  def purge
    @intervention.photos.find(params[:photo_id]).purge
    redirect_to @intervention, notice: "Photo supprimée"
  end

  private

    def send_workflow_changed_notification
      Events.instance.publish('intervention.workflow_changed', payload: {intervention_id: @intervention.id})
    end

    def send_intervention_termine_notification
      Events.instance.publish('intervention.done', payload: {intervention_id: @intervention.id})
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_intervention
      @intervention = Intervention.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def intervention_params
      params.require(:intervention).permit(:organisation_id, :agent_id, :agent_binome_id, :adherent_id, :début, :fin, :temps_de_pause, :description, :commentaires, :workflow_state, :tag_list, photos: [])
    end

    def is_user_authorized
      authorize @intervention ? @intervention : Intervention
    end

end
