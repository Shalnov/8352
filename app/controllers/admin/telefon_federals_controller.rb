# Controller generated by Typus, use it to extend admin functionality.
class Admin::TelefonFederalsController < Admin::MasterController
  include PhoneHelper
  
  def check_number
    @newnumber = Phone.normalize(params[:number])
  end

=begin

  ##
  # You can overwrite and extend Admin::MasterController with your methods.
  #
  # Actions have to be defined in <tt>config/typus/application.yml</tt>:
  #
  #   TelefonFederal:
  #     actions:
  #       index: custom_action
  #       edit: custom_action_for_an_item
  #
  # And you have to add permissions on <tt>config/typus/application_roles.yml</tt> 
  # to have access to them.
  #
  #   admin:
  #     TelefonFederal: create, read, update, destroy, custom_action
  #
  #   editor:
  #     TelefonFederal: create, read, update, custom_action_for_an_item
  #

  def index
  end

  def custom_action
  end

  def custom_action_for_an_item
  end

=end

end
