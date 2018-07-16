class ActivationController < ApplicationController
  def show
    @user = User.find_by(username: params[:username])
    if @user != nil && session[:id] == @user.id && @user.api_key == params[:api_key]
      update_hash = {activated: true}
      @user.update(update_hash)
      flash[:notice] = "Thank you! Your account is now activated."
      redirect_to "/dashboard/#{@user.id}"
    else
      session[:activate] = true
      flash[:notice] = "You must log in before you can fully activate your account."
      redirect_to login_path
    end
  end
end
