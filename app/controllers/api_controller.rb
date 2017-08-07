class APIController < ApplicationController

  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  layout false

  def authenticate_user!
    authenticate_with_http_token do |token, options|
      break unless token.present?

      user = AuthToken.find_by(token: token).try(:user)
      break unless user

      sign_in(user) and return
    end

    render_401
  end

  def render_401
    render json: {}, status: 401
  end

  def render_403(type, message)
    render_error(403, type, message)
  end

  def render_404(type, data = {})
    render_error(404, type, type.to_s.humanize, data)
  end

  def render_solution_not_found
    render_404(:solution_not_found) 
  end

  def render_error(status, type, message, data = {})
    render json: {
      error: {
        type: type,
        message: message
      }.merge(data)
    }, status: status
  end
end
