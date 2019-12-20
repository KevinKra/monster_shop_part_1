class Users::ProfileController < Users::BaseController
  def show
		# @user = User.find(params[:profile])
  end

	def edit_password

	end

	def update_password
	  @user = User.create(password_params)
	  if @user.password == @user.password_confirmation
			@user.save
			flash[:success] = "Your Password has been updated!"
	    redirect_to "/users/profile"
	  else
			flash[:error] = "The Password you entered did not match, Please try again"
	    redirect_to "/users/profile/edit_password"
	  end
	end

	private

 def password_params
	 params.permit(:password, :password_confirmation)
 end
end
