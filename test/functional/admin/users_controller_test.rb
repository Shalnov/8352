require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper 
  
  context "Admin users controller" do

    # управление пользователями доступно только админу
    context "get index" do
      context "logged as admin" do
        setup do
          login_as admin_user
          get :index
        end
        should_respond_with :success
        should_render_template :index
      end

      context "logged as editor" do
        setup do
          login_as editor_user
          get :index
        end
        should_respond_with :unauthorized
      end

      context "unauthorized" do
        setup do
          logout
          get :index
        end
        should_respond_with :redirect
        should_redirect_to("login page") { new_session_url }
      end
    end

    context "admin logged in" do
      setup do
        login_as admin_user
      end

      context "new user" do
        setup do
          @user = Factory.create(:user)
        end

        context "on GET to :edit" do
          setup do
            get :edit, :id => @user.id
          end
          should_assign_to :user
          should_respond_with :success
          should_render_template :edit
        end

        context "on PUT to :update" do
          setup do
            put :update, :id => @user.id, :user => @user.attributes
          end
          should_assign_to :user
          should_respond_with :redirect
          should_redirect_to("edit user page") { edit_admin_user_url(@user) }
        end
      end
    end

  end
end