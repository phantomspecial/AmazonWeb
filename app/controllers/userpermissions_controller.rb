class UserpermissionsController < AdminsController
  def index
    @users = User.all
  end

 def update
    user = User.find(params[:id])
    if user.admin_flg == true
      user.admin_flg = nil
    else
      user.admin_flg = true
    end
    user.save
    redirect_to :back
  end
end
