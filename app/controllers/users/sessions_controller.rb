class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]
  respond_to :html, :json

  def create
    # Custom logic to handle sign in
    self.resource = warden.authenticate!(auth_options)  # Authenticate the user
    set_flash_message!(:notice, :signed_in)

    sign_in(resource_name, resource)  # Sign in the resource

    if request.format.json?
      # Generate JWT token here using Devise JWT's helper method
      token = generate_jwt_token(resource)
      render json: { user: resource, jwt: token }, status: :ok and return
    else
      super
    end
  end

  def destroy
    super do |resource|
      if request.format.json?
        render json: { message: 'Signed out successfully' }, status: :ok and return
      end
    end
  end

  private

  # Helper method to generate JWT token
  def generate_jwt_token(user)
    # Use Devise JWT's `encode` method (or your custom method) to generate a token for the user
    JWT.encode({ sub: user.id, exp: 24.hours.from_now.to_i }, Rails.application.secret_key_base)
  end
end
