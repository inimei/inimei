class Blog::Admin::UsersController < Blog::Admin::BaseController

  before_filter :load_user, except: [:index, :new, :create]

  def edit

  end

  def new
    @user = User.new
  end

  def update
    if @user.update user_params
      flash.notice = 'User modified'
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, notice:  I18n.t("blog.admin.users.delete.removed", user: @user.name)
    else
      redirect_to admin_users_path, alert: I18n.t("blog.admin.users.delete.failed", user: @user.name)
   end
  end

  def create
    @user = User.new user_params
    if @user.save
      flash.notice = I18n.t("blog.admin.users.create.success")
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def index
    @users = User.all
  end

  private
    def load_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
