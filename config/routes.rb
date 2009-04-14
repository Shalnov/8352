ActionController::Routing::Routes.draw do |map|
  map.resources :tags


  map.root :controller => "home"

  map.namespace :admin do |admin|
#    map.with_options :path_prefix => '/admin' do |admin_path|
      admin.resources :users,      :controller => 'users'
      admin.resources :companies,  :controller => 'companies'
      admin.resources :categories, :controller => 'categories'
      admin.resources :tags,       :controller => 'tags'
#    end

    admin.connect '/', :controller => 'companies', :action => 'index'
  end

  map.logout    '/logout',    :controller => 'sessions',  :action => 'destroy'
  map.login     '/login',     :controller => 'sessions',  :action => 'new'
  map.register  '/register',  :controller => 'users',     :action => 'create'
  map.signup    '/signup',    :controller => 'users',     :action => 'new'

  map.resources :users,       :collection => { :activate => :get }
  map.resource  :session
  map.resources :companies
  map.resources :categories, :has_many => [:companies]

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
