authorization do
  role :guest do
    has_permission_on :users, :to => [:read_index,:create]
    #has_permission_on :archives, :to => [:index, :show, :create, :new, :update, :edit]
  end

  role :user do
    includes :guest
    has_permission_on :users, :to => [:read_show,:update] do
      if_attribute :id => is {user.id}

    end
  end
  
  role :archive_read do
    includes :users
    has_permission_on :archives, :to => :read
  end

  role :archive_write do
    includes :archive_viewer
     has_permission_on :archives, :to => :manage
  end
  
  role :admin do
    includes :users
    has_permission_on :users, :to => :manage
    has_permission_on :archives, :to => :manage
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
