ActionController::Routing::Routes.draw do |map|
  map.resources :telefon_renames

  map.resources :telefon_federals

  
  map.root :controller => "home"

  map.namespace :admin do |admin|
    admin.resources :users
    admin.resources :companies
    admin.resources :categories
    admin.resources :tags

    admin.resources :sources, :member => { :run => :get } do |source|
      source.resources :links
      source.resources :results, :collection => { :export => :get, :move => :post }
    end
    admin.resources :jobs
    admin.resources :storages



    admin.connect '/', :controller => 'companies', :action => 'index'
  end

  map.logout    '/logout',    :controller => 'sessions',  :action => 'destroy'
  map.login     '/login',     :controller => 'sessions',  :action => 'new'
  map.register  '/register',  :controller => 'users',     :action => 'create'
  map.signup    '/signup',    :controller => 'users',     :action => 'new'

  map.resources :users,       :collection => { :activate => :get }
  map.resource  :session
  map.resources :companies,   :collection => { :search => :post }
  map.resources :categories,  :has_many => [:companies]
  map.resources :tags,        :has_many => [:companies]

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
