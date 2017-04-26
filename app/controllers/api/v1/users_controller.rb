module Api
  module V1
    class UsersController < ApplicationController
      respond_to :json

      def create
        user = User.new(user_params)

        if user.save
          respond_with user.attributes, location: nil
        else
          errors = { errors: user.errors }
          respond_with errors, location: nil, status: 404
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :first_name, :last_name,
                                     :about_me)
      end
    end
  end
end
