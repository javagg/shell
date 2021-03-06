ActionController::Routing::Routes.draw do |map|
  map.resources :user_ycroles, :active_scaffold => true
  map.resources :ycroles, :active_scaffold => true
  map.resources :documents, :active_scaffold => true
  map.resources :contracts, :collection => { :upload_xls_file => :get, :delete_marked => :get, :export => :get }, :active_scaffold => true do |contract|
    contract.resources :payments, :active_scaffold => true
    contract.resources :payment_periods
    contract.resources :reminding_periods
    contract.resources :expiration_remindees
    contract.resources :attachments, :member => { :download => :get }
  end
  
  map.resources :expiration_remindings, :active_scaffold => true
  
  map.resources :licenses, :collection => { :upload_xls_file => :get, :delete_marked => :get, :export => :get }, :active_scaffold => true do |license|
    license.resources :expiration_remindees
    license.resources :reminding_periods
    license.resources :attachments, :member => { :download => :get }
  end
  
  map.resources :archives, :collection => { :upload_xls_file => :get, :delete_marked => :get, :export => :get }, :active_scaffold => true do |archive|
    archive.resources :expiration_remindees
    archive.resources :reminding_periods
    archive.resources :attachments, :member => { :download => :get }
  end
  
  map.resources :settings, :active_scaffold => true
  
  map.resources :users, :active_scaffold => true do |user|
    user.resources :expiration_remindings, :active_scaffold => true
    user.resources :payment_remindings, :active_scaffold => true
  end

  map.resources :audits, :collection => { :empty => :get }, :active_scaffold => true
  map.resources :roles, :collection => { :browse => :get }, :member => { :select => :post }

  map.resource :user_session
  map.resources :accounts
  map.resources :password_resets, :only => [:new, :create, :edit, :update]

  map.batch_permissions '/batch_permissions', :controller => 'ycroles', :action => 'batch_permissions'
  map.with_options :controller => 'site' do |site|
    site.home '', :action => 'index'
    site.help '/help', :action => 'help'
    site.contact 'contact', :action => 'contact'
    site.about '/about', :action => 'about'
    site.download '/download', :action => 'download'
    site.test_email '/test_email', :action => 'test_email'
  end

  map.activate '/activate/:activation_code', :controller => 'activations', :action => 'create'

  map.root :controller => 'site'
  
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
