class ApplicationController < ActionController::Base
    helper_method :current_user

  def current_user
    # Implement your logic to retrieve the current user
    # This can vary depending on your authentication system
    # For example, with Devise, you can use `current_user` directly
    # Replace this with your own implementation
    Usuario.find_by(id: session[:user_id])
  end
end
