module Api
  module V1
    class BaseController < ApplicationController
      private

      def authenticate_with_token
        @user = User.find_by(encrypted_password: params[:token])
        render json: { errors: 'Invalid Credentials' }, status: 401 if @user.nil?
        return if @user.nil?
      end
    end
  end
end
