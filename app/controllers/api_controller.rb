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
end
