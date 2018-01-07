module ApplicationHelper
  # 最初に作成するユーザであれば、無条件でadmin_flgをtrueにする
  def privilege_elevate
    @users = User.all
    if @users.empty?
      return true
    else
      return false
    end
  end
end
