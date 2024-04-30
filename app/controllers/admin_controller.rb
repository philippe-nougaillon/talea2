class AdminController < ApplicationController
  include Pagy::Backend

  def audits
    @organisation_audits = Audited::Audit.where(user_id: current_user.organisation.users.pluck(:id))
    @audits = @organisation_audits.order("id DESC")
    @types  = @organisation_audits.pluck(:auditable_type).uniq.sort
    @actions= %w[update create destroy]

    if params[:start_date].present? && params[:end_date].present? 
      @audits = @audits.where("created_at BETWEEN (?) AND (?)", params[:start_date], params[:end_date])
    end

    if params[:type].present?
      @audits = @audits.where(auditable_type: params[:type])
    end

    if params[:action_name].present?
      @audits = @audits.where(action: params[:action_name])
    end

    if params[:search].present?
      @audits = @audits.where("audited_changes ILIKE ?", "%#{params[:search]}%")
    end

    @pagy, @audits = pagy(@audits)
  end
end
