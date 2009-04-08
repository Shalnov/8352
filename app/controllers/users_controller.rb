class UsersController < ApplicationController

  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      
      @user.activate! if ENV["RAILS_ENV"] == "development"

      flash[:notice] = "Спасибо за регистрацию. Письмо с кодом активации отправлено вам на почту."
      redirect_back_or_default('/')
    else
      flash[:error]  = "Ошибка создания учетной записи."
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Регистрация завершена, пожалуйста, залогиньтесь."
      redirect_to login_url
    when params[:activation_code].blank?
      flash[:error] = "Учетная запись не активирована, пожалуйста, откройте ссылку из письма."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "Неверный код активации."
      redirect_back_or_default('/')
    end
  end
end
