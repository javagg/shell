ActionController::Routing::Routes.draw do |map|
  map.resources :documents, :active_scaffold => true
  map.resources :contracts, :active_scaffold => true, :active_scaffold_sortable => true do |contract|
    contract.resources :payments
  end
  map.resources :licenses, :active_scaffold => true
  map.resources :archives, :active_scaffold => true
  map.resources :settings, :active_scaffold => true
  map.resources :users, :active_scaffold => true

  map.resource :user_session
  map.resources :accounts
  map.resources :password_resets, :only => [:new, :create, :edit, :update]

  map.with_options :controller => 'site' do |site|
    site.home '', :action => 'index'
    site.help '/help', :action => 'help'
    site.contact 'contact', :action => 'contact'
    site.about '/about', :action => 'about'
  end

  map.activate '/activate/:activation_code', :controller => 'activations', :action => 'create'

  map.root :controller => 'site'
  
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
