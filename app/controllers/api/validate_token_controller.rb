class API::ValidateTokenController < APIController
  def index
    render json: {
      status: {
        token: 'valid',
      }
    }, status: 200
  end
end
