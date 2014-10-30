class SessionsController < ApplicationController
  before_action :require_current_user!, except: [:create, :new]
    
  def create
    @user = User.find_by_credentials(
              params[:user][:user_name],
              params[:user][:password])
    
    if @user.nil?
      render json: "Wrong credentials"
    else
      @user.reset_session_token!
      session[:session_token] = @user.session_token
      redirect_to cats_url
    end
  end

  def new
    @user = User.new
    render :new
  end

  def destroy
    logout 
    redirect_to new_session_url
  end

end
