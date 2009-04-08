module AuthenticatedTestHelper
  # Sets the current user in the session from the user fixtures.
  def login_as(user, fixtures = false)
    @request.session[:user_id] = user ? (user.is_a?(User) ? user.id : (fixtures ? users(user) : Factory(user)).id) : nil
  end

  def logout
    @request.session[:user_id] = nil
  end
  
  def admin_user
    if @admin.nil?
      @admin = Factory.create(:user)
      @admin.roles << Factory.create(:admin_role)
    end
    @admin
  end
  
  def editor_user
    if @editor.nil?
      @editor = Factory.create(:user)
      @editor.roles << Factory.create(:editor_role)
    end
    @editor
  end
  
  def authorize_as(user)
    @request.env["HTTP_AUTHORIZATION"] = user ? ActionController::HttpAuthentication::Basic.encode_credentials(users(user).login, 'monkey') : nil
  end
  
end
