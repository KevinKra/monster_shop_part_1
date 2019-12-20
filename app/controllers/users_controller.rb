class UsersController < ApplicationController
	before_action :require_user, only: [:show, :index]

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
    if @user.save
      flash[:success] = "Welcome, #{@user.name}"
      session[:user_id] = @user.id
      redirect_to "/profile"
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

		def require_user
			redirect_to "/public/404" unless current_user
		end
end
