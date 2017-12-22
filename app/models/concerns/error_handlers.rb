module ErrorHandlers
  extend ActiveSupport::Concern

  included do
    rescue_from ApplicationController::Forbidden, with: :rescue403
    rescue_from ApplicationController::IpAddressRejected, with: :rescue403
  end

  private
  def rescue403(e)
    @exception = e
    render 'errors/forbidden', status: 403
  end
end
