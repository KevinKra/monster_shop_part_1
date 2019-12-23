 class SessionsController < ApplicationController
	def new
    if current_admin?
      redirect_to "/admin/dashboard"
      flash[:notice] = "You are already logged in."
    elsif current_merchant?
      redirect_to "/merchants/dashboard"
      flash[:notice] = "You are already logged in."
    elsif current_default?
      redirect_to "/profile"
      flash[:notice] = "You are already logged in."
    end
	end

	def create
  user = User.find_by(email: params[:email])
    if user != nil && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      if user.admin?
        redirect_to '/admin/dashboard'
        flash[:success] = "Welcome, #{user.name}. You are logged in as an Admin."
      elsif user.merchant?
        redirect_to '/merchants/dashboard'
        flash[:success] = "Welcome, #{user.name}. You are logged in as a Merchant."
      elsif user.default?
        redirect_to '/profile'
        flash[:success] = "Welcome, #{user.name}."
      else
        # redirect_to "/"
        # flash[:failure] = "Sorry, something went wrong."
      end
    else
      flash.now[:notice] = "Sorry, wrong username or password."
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    session.delete(:cart)
    flash[:success] = "You have been signed out."
    redirect_to "/welcome/home"
	end
end
