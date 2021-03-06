class UsersController < ApplicationController
	before_action :require_user, only: [:show, :index]

	def show
		user_show
	end

  def new
    new_user
	end

	def create
		new_user
    if @user.save
      flash[:success] = "Welcome, #{@user.name}"
      session[:user_id] = @user.id
      redirect_to "/profile"
    else
      flash[:error] = @user.errors.full_messages.to_sentence
			redirect_to '/register'
		end
	end

	def update
		user_show.update(user_params)
		flash[:success] = "Updates saved!"
		redirect_to "/profile"
	end

	def edit_password
	end

	def update_password
		@user = User.find_by(id: current_user.id)
		@user.update(password_params)
	  if @user.save
			flash[:success] = "Your Password has been updated!"
	    redirect_to "/profile"
	  else
			flash[:error] = "The Password you entered did not match, Please try again"
	    redirect_to "/profile/edit_password"
	  end
	end

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
				:password_confirmation)
		end

		def require_user
			redirect_to "/public/404" unless current_user
		end

		def user_show
			@user = User.find(session[:user_id])
		end

		def new_user
			@user = User.new(user_params)
		end

end
