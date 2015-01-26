module ApplicationHelper

  include Spree::Core::ControllerHelpers


  def is_admin?
    if spree_current_user
      spree_current_user.has_spree_role?('admin')
    end
  end


  def require_login
    if spree_current_user
      unless spree_current_user.has_spree_role?('admin')
        redirect_to spree_login_path
      end
    else
      redirect_to spree_login_path
    end
  end

end
