class RegistrationsController < Devise::RegistrationsController
  def create
    user = User.new(sign_up_params)

    if user.save
      flash[:notice] = 'Welcome! You have signed up successfully. Login to get started.'
      redirect_to root_path
    else
      flash[:notice] = user.errors.map { |key, value| "#{key} #{value}" }.join("\n")
      redirect_to new_user_registration_path
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password,
                                 :password_confirmation, :about_me)
  end
end
