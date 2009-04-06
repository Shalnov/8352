ActionController::Routing::Routes.draw do |map|

  map.namespace :admin do |admin|
    map.with_options :path_prefix => '/admin' do |admin_path|
      admin_path.resources :users,      :controller => 'admin/users'
      admin_path.resources :companies,  :controller => 'admin/companies'
      admin_path.resources :categories, :controller => 'admin/categories'
      admin_path.resources :tags,       :controller => 'admin/tags'
    end

    admin.connect '/', :controller => 'companies', :action => 'index'
  end

  map.root :controller => "home"

  map.logout    '/logout',    :controller => 'sessions',  :action => 'destroy'
  map.login     '/login',     :controller => 'sessions',  :action => 'new'
  map.register  '/register',  :controller => 'users',     :action => 'create'
  map.signup    '/signup',    :controller => 'users',     :action => 'new'

  map.resources :users
  map.resource  :session
  map.resources :companies
  map.resources :categories, :has_many => [:companies]

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
