module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_user!, only: [:create]
    end
  end
end
