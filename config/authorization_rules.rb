authorization do
  role :guest do
    has_permission_on :users, :to => [:read_index, :create]
  end

  role :user do
    includes :guest
    has_permission_on :users, :to => [:read_show, :update] do
      if_attribute :id => is {user.id}
    end
  end
  
  role :archive_view do
    includes :users
    has_permission_on :archives, :to => :read
  end

  role :archive_manage do
    includes :archive_view
    has_permission_on :archives, :to => :manage
  end

  role :license_view do
    includes :users
    has_permission_on :licenses, :to => :read
  end

  role :license_manage do
    includes :license_view
    has_permission_on :licenses, :to => :manage
  end

  role :contract_view do
    includes :users
    has_permission_on :contracts, :to => :read
  end

  role :contract_manage do
    includes :contract_view
    has_permission_on :contracts, :to => :manage
  end

  role :admin do
    includes :archive_manage, :license_manage, :contract_manage
    has_permission_on :users, :to => :manage
    has_permission_on :settings, :to => :manage
  end
end

privileges do
  # default privilege hierarchies to facilitate RESTful Rails apps
  privilege :manage, :includes => [:create, :read, :update, :delete, :edit_associated]
  privilege :read, :includes => [:index, :show, :download, :row, :show_search, :search, :list, :nested, :subform]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end
