ActionController::Routing::Routes.draw do |map|
  map.resources :audits, :active_scaffold => true
  map.resources :documents, :active_scaffold => true
  map.resources :contracts, :active_scaffold => true do |contract|
    contract.resources :payments
    contract.resources :payment_periods
    contract.resources :reminding_periods
    contract.resources :attachments, :member => { :download => :get }
  end

  map.resources :licenses, :active_scaffold => true do |license|
    license.resources :expiration_remindees
    license.resources :reminding_periods
    license.resources :attachments, :member => { :download => :get }
  end
  
  map.resources :archives, :active_scaffold => true do |archive|
    archive.resources :attachments, :member => { :download => :get }
    archive.resources :expiration_remindees
    archive.resources :reminding_periods
  end
  
  map.resources :settings, :active_scaffold => true
  map.resources :users, :active_scaffold => true
  
  map.resources :audits, :active_scaffold => true
  
  map.resources :roles, :collection => {:browse => :get}, :member => {:select => :post}

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
