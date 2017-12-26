class UsersController < ApplicationController
  def index
    # アカウントサービス画面
    @user = current_user

  end

  def show
    # マイストア画面

  end

end
