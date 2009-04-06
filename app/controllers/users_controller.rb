class UsersController < ApplicationController

  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = "Спасибо за регистрацию. На указанный e-mail отправлено письмо с кодом для активации."
    else
      flash[:error]  = "Ошибка создания учетной записи."
      render :action => 'new'
    end
  end
end
