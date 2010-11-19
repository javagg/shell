module UsersHelper
  def options_for_association_conditions(association)
    if association.name == :roles
      ['roles.id != ?','admin'] unless current_user.is_admin?
    else
      super
    end
  end
end
