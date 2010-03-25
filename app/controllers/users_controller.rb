class UsersController < ApplicationController
  before_filter :require_no_user
  filter_parameter_logging 'password', 'password_confirmation'

  def new
    @user = User.new
  end

  def create
    # No simple mass assigment for security reasons
    @user = User.new(
      :login                 => params[:user][:login],
      :email                 => params[:user][:email],
      :password              => params[:user][:password],
      :password_confirmation => params[:user][:password_confirmation]      
    )

    if @user.save
      UserSession.create!(@user)
      flash[:notice] = "Welcome, #{current_user.login}."
      redirect_back_or_default(root_path)
    else
      render :action => 'new'
    end
  end

  def forgot
    if request.post?
      if (user = User.find_by_email(params[:user][:email])).present?
        flash[:notice] = "An email has been sent to #{user.email} with a link to reset your password."
        user.deliver_password_reset_instructions!(request)
        redirect_back_or_default forgot_url
      else
        flash[:notice] = "Sorry, #{params[:user][:email]} isn't associated with any accounts. Are you sure you typed the correct email address?"
      end
    end
  end

  def reset
    if params[:reset_code] and @user = User.find_using_perishable_token(params[:reset_code])
      if request.post?
        if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
          flash[:notice] = "Password reset successfully for #{@user.email}"
          UserSession.create(@user)
          redirect_back_or_default root_url
        end
      end
    else
      flash[:notice] = "We're sorry, but this reset code has expired or is invalid." +
        "If you are having issues try copying and pasting the URL " +
        "from your email into your browser or restarting the " +
        "reset password process."
      redirect_to forgot_url
    end
  end

protected
  def take_down_for_maintenance?;end
end