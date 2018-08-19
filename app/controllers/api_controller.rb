class APIController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  rescue_from ActionController::RoutingError, with: -> { render_404  }

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

  def guard_js_ecma_migration!(track)
    if track.slug == "js" || track.slug == "ecmascript"
      render_400(:js_ecma_migration, "We are currently merging the JavaScript and ECMAScript tracks. They will be offline for the next couple of hours. Sorry.")
      true
    else
      false
    end
  end

  def render_401
    render json: {}, status: 401
  end

  def render_403(type, message)
    render_error(403, type, message)
  end

  def render_404(type = :resource_not_found, data = {})
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
