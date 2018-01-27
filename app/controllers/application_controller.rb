class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def render_404
    render plain: '404 not found', status: 404
  end
end
