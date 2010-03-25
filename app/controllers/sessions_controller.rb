class SessionsController < ApplicationController
  filter_parameter_logging 'password', 'password_confirmation'

  def create
    @session = UserSession.new(params[:session])
    if @session.save
      redirect_back_or_default(root_path)
      flash[:notice] = "Logged in successfully"
    else
      render :action => 'new'
    end
  end

  def destroy
    current_user_session.destroy if logged_in?
    flash[:notice] = "You have been logged out."
    redirect_to root_path
  end

protected
  def take_down_for_maintenance?;end
end