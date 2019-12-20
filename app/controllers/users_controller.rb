class UsersController < ApplicationController
	before_action :require_user, only: [:show, :index]

  def index
		@users = User.all
  end

	def show
    # require "pry"; binding.pry
		# @user = User.find(session[:user_id])  #### I moved this to the profile user show
	end

  def new
    @user = User.new(user_params)
	end

  def update
    # require "pry"; binding.pry
    @user = User.find(params[:id])
    @user.update(user_params)
    if @user.save
      redirect_to "/users/profile"
      flash[:success] = "Updates saved!"
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :edit
    end
  end

	def create
		@user = User.new(user_params)
		# binding.pry
    if @user.save && @user.password == @user.password_confirmation
      flash[:success] = "Welcome, #{@user.name}"
      session[:user_id] = @user.id
      redirect_to "/profile"
		elsif !@user.save && @user.password == @user.password_confirmation
			flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to "/register"
    else
      flash[:error] = @user.errors.full_messages.to_sentence
			redirect_to '/register'
		end
	end

<<<<<<< HEAD
  def edit
    @user = User.find(session[:user_id])
  end
=======
	def edit_password
	end

	def update_password
		@user = User.find_by(id: current_user.id)
		@user.update(password_params)
	  if @user.save && @user.password == @user.password_confirmation
			flash[:success] = "Your Password has been updated!"
	    redirect_to "/profile"
	  else
			flash[:error] = "The Password you entered did not match, Please try again"
	    redirect_to "/profile/edit_password"
	  end
	end
>>>>>>> 39335a89549adab0bd1941aad774bd78dae360c0

	private
	def password_params
		params.permit(:password, :password_confirmation)
	end

	def user_params
		params.permit(
			:name,
			:street_address,
			:city,
			:state,
			:zip,
			:email,
			:password,
			:password_confirmation
		)
	end

	def require_user
		redirect_to "/public/404" unless current_user
	end
end
