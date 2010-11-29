authorization do
  role :guest do
    has_permission_on :users, :to => [:index, :create, :show_search, :nested, :row]
    has_permission_on :users, :to => [:show, :update] do
      if_attribute :id => is {user.id}    
    end
  end

  role :attachment_view do
    has_permission_on :attachments, :to => :read
  end
  
  role :attachment_manage do
    includes :attachment_view
    has_permission_on :attachments, :to => :manage
  end

  role :user do
    includes :guest
  end

  role :archive_view do
    includes :user
    includes :attachment_view
    has_permission_on :archives, :to => :read
  end

  role :archive_manage do
    includes :archive_view
    includes :attachment_manage
    has_permission_on :archives, :to => :manage
  end

  role :license_view do
    includes :user
    includes :attachment_view
    has_permission_on :licenses, :to => :read
  end

  role :license_manage do
    includes :license_view
    includes :attachment_manage
    has_permission_on :licenses, :to => :manage
  end

  role :contract_view do
    includes :user
    includes :attachment_view
    has_permission_on :contracts, :to => :read
  end

  role :contract_manage do
    includes :contract_view
    includes :attachment_manage
    has_permission_on :contracts, :to => :manage
  end

  role :admin do
#    includes :archive_manage, :license_manage, :contract_manage
#    has_permission_on :users, :to => :manage
#    has_permission_on :settings, :to => :manage
#    has_permission_on :audits, :to => :read
     has_omnipotence
  end
end

privileges do
  # default privilege hierarchies to facilitate RESTful Rails apps
  privilege :manage, :includes => [:edit, :create, :read, :update, :delete, :edit_associated]
  privilege :read, :includes => [:index, :show_search, :nested, :show, :row, :mark]

  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end
