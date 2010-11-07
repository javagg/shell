ActionController::Routing::Routes.draw do |map|
  map.resources :documents, :active_scaffold => true
  map.resources :archives, :active_scaffold => true
  map.resource :user_session
  map.resource :account, :controller => "users"
  map.resources :users, :controller => "admin", :active_scaffold => true

  map.resources :password_resets, :only => [:new, :create, :edit, :update]

  map.with_options :controller => 'site' do |site|
    site.home '', :action => 'index'
    site.help '/help', :action => 'help'
    site.contact 'contact', :action => 'contact'
    site.about '/about', :action => 'about'
  end

  map.activate '/activate/:activation_code', :controller => 'activations', :action => 'create'

  map.root :controller => 'site'
  #  map.login '/login', :controller => 'users', :action => "login"
  #  map.register '/register', :controller => 'users', :action => 'register'
  #  map.logout '/logout', :controller => 'users', :action => 'logout'
  
  map.connect ':controller/service.wsdl', :action => 'wsdl'

#  map.connect ':controller/:action'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
