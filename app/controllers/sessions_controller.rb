class SessionsController < ApplicationController

  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      # Sign the user in and redirect to the user's show page.
      flash[:success] = "Sign in successfully!"
      redirect_to user
    else
      # Create an error message and re-render the signin form.
      flash[:notice] = "Invalid email/password. Try again!"
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
