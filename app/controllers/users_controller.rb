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

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    if @user.save
      redirect_to "users_profile"
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :edit
    end
  end

	def create
		@user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome, #{@user.name}"
      session[:user_id] = @user.id
      redirect_to "/users/profile"
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :new
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
				:password
			)
		end
end
