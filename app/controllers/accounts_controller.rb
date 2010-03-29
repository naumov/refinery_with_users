class AccountsController < ApplicationController
  before_filter :require_user
  filter_parameter_logging 'password', 'password_confirmation'

  def show
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Account was updated.'
      redirect_to :action=>'show'
    else
      render :action=>'show'
    end
  end
end