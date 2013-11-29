class RegistrationsController < Devise::RegistrationsController


	def new
		redirect_to new_user_session_path
	end

	def edit
		redirect_to new_user_session_path
	end

end

