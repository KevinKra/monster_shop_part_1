class UsersController < ApplicationController

  def index
		@users = User.all
  end

	def show
		@user = User.find(session[:user_id])
	end

  def new
    @user = User.new(user_params)
	end

	def create
		@user = User.new(user_params)
    if @user.save && @user.password == @user.password_confirmation
      flash[:success] = "Welcome, #{@user.name}"
      session[:user_id] = @user.id
      redirect_to "/users/profile"
    elsif !@user.save && @user.password == @user.password_confirmation
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to '/register'
		else 
			flash[:error] = "The password and password confirmation to not match"
			redirect_to '/register'
    end
	end


	private
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
end
