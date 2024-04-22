class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :prepare_exception_notifier

  private

  def prepare_exception_notifier
    request.env["exception_notifier.exception_data"] = {
      current_user: current_user
    }
  end
end
