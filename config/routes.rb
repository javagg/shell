ActionController::Routing::Routes.draw do |map|
  map.resources :documents, :active_scaffold => true
  map.resources :contracts, :active_scaffold => true, :active_scaffold_sortable => true do |contract|
    contract.resources :payments
    contract.resources :payment_periods
  end

  map.resources :licenses, :active_scaffold => true do |license|
    license.resources :attachments, :member => { :download => :get }
  end
  
  map.resources :archives, :active_scaffold => true
  map.resources :settings, :active_scaffold => true
  
  map.resources :users, :active_scaffold => true, :collection => {:browse => :get}, :member => {:select => :post} do |user|
#    user.resources :roles, :active_scaffold => true, :collection => {:browse => :get}, :member => {:select => :post}
  end

  map.resources :roles, :collection => {:browse => :get}, :member => {:select => :post}
  
#  map.resources :attachments, :member => { :download => :get }
  
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
