class UsersController < ApplicationController
  def index
    # アカウントサービス画面
  end

  def show
    @user = current_user
    # マイストア画面
  end

end
