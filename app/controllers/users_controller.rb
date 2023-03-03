class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @users = User.order(:id).page(params[:page])
  end

  def show
    @user
  end

  def set_user
    @user = User.find(params[:id])
  end

end
