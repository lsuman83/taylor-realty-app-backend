class CurrentUserController < ApplicationController
  before_action :authenticate_user!

  
  def index
    byebug
    render json: current_user, status: :ok
  end

  
end
