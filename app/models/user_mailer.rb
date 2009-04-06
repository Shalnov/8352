class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Пожалуйста, активируйте учетную запись.'
  
    @body[:url]  = "http://#{configatron.site_url}/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Ваша учетная запись активирована.'
    @body[:url]  = "http://#{configatron.site_url}/"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = configatron.admin_email
      @subject     = "[#{configatron.site_url}] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
