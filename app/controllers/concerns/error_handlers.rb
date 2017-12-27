module ErrorHandlers
  extend ActiveSupport::Concern

  included do
    rescue_from ApplicationController::Forbidden, with: :rescue403
    rescue_from ApplicationController::IpAddressRejected, with: :rescue403
    rescue_from ActionController::RoutingError, with: :rescue404
    rescue_from ActiveRecord::RecordNotFound, with: :rescue404
  end

  private
  def rescue403(e)
    @exception = e
    render 'errors/forbidden', status: 403
  end

  def rescue404(e)
    @exception = e
    render 'errors/notfound', status: 404
  end
end
