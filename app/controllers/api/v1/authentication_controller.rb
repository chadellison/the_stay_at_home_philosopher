module Api
  module V1
    class AuthenticationController < ApplicationController
      respond_to :json

      def create
        user = User.find_by(email: login_params[:email].downcase)

        if user && user.valid_password?(login_params[:password])
          respond_with user.attributes, location: nil, status: 200
        else
          message = { errors: 'Invalid Credentials' }
          respond_with message, location: nil, status: 404
        end
      end

      private

      def login_params
        params.require(:credentials).permit(:email, :password)
      end
    end
  end
end
