require File.dirname(__FILE__) + '/../test_helper' 
#require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper 
  
  context "get index" do
    setup do
      @controller = CompaniesController.new
    end

    context "logged in" do
      setup do
        login_as :user
        get :index
      end
      should_render_template :index
      should_respond_with :success
    end

    context "unauthorized" do
      setup do
        logout
        get :index
      end
#      should_respond_with :redirect
      should_redirect_to("login page") { session_url }
    end
  end
end