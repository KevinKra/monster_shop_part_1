class UsersController < ApplicationController

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
    if @user.save
      flash[:success] = "Welcome, #{@user.name}"
      session[:user_id] = @user.id
      redirect_to "/users/profile"
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :new
    end
	end

  def edit
    @user = User.find(session[:user_id])
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
