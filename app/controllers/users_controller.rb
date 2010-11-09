class UsersController < ApplicationController
  #before_filter :require_no_user, :only => [:new, :create, :remind_password]
  #before_filter :require_user, :only => [:show, :edit, :update]

  filter_access_to :all
  filter_access_to :edit, :update, :attribute_check => true
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    # Saving without session maintenance to skip
    # auto-login which can't happen here because
    # the User has not yet been activated
    if @user.save_without_session_maintenance
      @user.deliver_activation_instructions!
      flash[:notice] = t 'txt.check_email_for_activation'
      redirect_to root_url
      # redirect_back_or_default account_url
    else
      render :action => :new
    end

  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  def show
    @user = @current_user
  end

  def edit
    @user = @current_user
  end

  def update
    @user = @current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = t 'txt.account_updated'
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end
