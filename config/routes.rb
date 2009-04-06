ActionController::Routing::Routes.draw do |map|

  map.root :controller => "home"

  map.resources :companies
  map.resources :categories

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
