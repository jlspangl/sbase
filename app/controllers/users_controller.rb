class UsersController < ApplicationController

  #  ToDo:  should be   admin-accessible only
  #  lists the unapproved users
  #  and provides a simple way to approve them.

  def index
    @search = User.search(params[:q])
    @users = @search.result(:distinct => true)
    @users = @users.paginate(:page => params[:page], :per_page => 10)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "User updated"
      redirect_to users_url
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end
end
