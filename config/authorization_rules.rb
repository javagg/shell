authorization do
  role :guest do
    has_permission_on :users, :to => [:read_index,:create]
  end

  role :user do
    includes :guest
    has_permission_on :users, :to => [:read_show, :update] do
      if_attribute :id => is {user.id}
    end
  end
  
  role :archive_read do
    includes :users
    has_permission_on :archives, :to => :read
  end

  role :archive_write do
    includes :archive_read
    has_permission_on :archives, :to => :manage
  end

  role :license_read do
    includes :users
    has_permission_on :licenses, :to => :read
  end

  role :license_write do
    includes :license_read
    has_permission_on :licenses, :to => :manage
  end

  role :contract_read do
    includes :users
    has_permission_on :contracts, :to => :read
  end

  role :contract_write do
    includes :contract_read
    has_permission_on :contracts, :to => :manage
  end

  role :admin do
    includes :archive_write, :license_write, :contract_write
    has_permission_on :users, :to => :manage
  end
end

privileges do
  # default privilege hierarchies to facilitate RESTful Rails apps
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end
