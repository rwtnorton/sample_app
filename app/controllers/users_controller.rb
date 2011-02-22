class UsersController < ApplicationController

  before_filter :authenticate,        :only => [:edit, :update, :index,
                                                :destroy]
  before_filter :ensure_correct_user, :only => [:edit, :update]
  before_filter :ensure_admin_user,   :only => [:destroy]
  before_filter :ensure_signed_out,   :only => [:new, :create]

  def index
    @title = 'All users'
    @users = User.paginate(:page => params[:page])
  end

  def new
    @user = User.new
    @title = 'Sign up'
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def create
    @user = User.new params[:user]
    if @user.save
      sign_in @user
      flash[:success] = 'Welcome to the Sample App'
      redirect_to @user
    else
      @title = 'Sign up'
      @user.password = @user.password_confirmation = ''
      render :new
    end
  end

  def edit
    @title = 'Edit user'
    @user = User.find(params[:id])
  end

  def update
    @user = User.find params[:id]
    if @user && @user.update_attributes(params[:user])
      flash[:success] = 'Profile updated.'
      redirect_to @user
    else
      @title = 'Edit user'
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    if user == current_user
      flash[:error] = 'Delete failed.  Cannot delete yourself.'
    else
      user.destroy
      flash[:success] = "User '%s' (%d) <%s> deleted." % [
        user.name, user.id, user.email
      ]
    end
    redirect_to users_path
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

    def ensure_correct_user
      user = User.find(params[:id])
      redirect_to root_path unless current_user? user
    end

    def ensure_admin_user
      redirect_to root_path unless current_user.admin?
    end

    def ensure_signed_out
      redirect_to root_path if signed_in?
    end

end
