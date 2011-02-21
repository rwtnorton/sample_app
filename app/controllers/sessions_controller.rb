class SessionsController < ApplicationController

  def new
    @title = 'Sign in'
  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user
#      flash[:success] = "Welcome back #{user.name}!"
      sign_in user
      redirect_to user
    else
      flash.now[:error] = 'Invalid credentials'
      @title = 'Sign in'
      render 'new'
    end
  end

  def destroy
  end

end
