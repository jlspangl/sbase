class XSessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the home page.
      sign_in user
      redirect_back_or root_url
    else
      # Create an error message and re-render the signin form.
      # Note: flash.now is used when displaying flash messages on rendered pages
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
    if current_user != nil
      logger.info("current_user is NOT nil")
    else
      logger.info("current_user is nil")
    end

  end

end