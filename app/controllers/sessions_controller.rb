class SessionsController < ApplicationController

  # This is contained within omniauth.
  skip_before_action :verify_authenticity_token

  def new
    session[:referer] = request.env['HTTP_REFERER']
    if Rails.env.production?
      redirect_to(shibboleth_login_path(Sead2DspaceAgentGui::Application.shibboleth_host))
    else
      redirect_to('/auth/developer')
    end
  end

  ##
  # Responds to POST /auth/:provider/callback
  #
  def create
    auth_hash = request.env['omniauth.auth']
    if auth_hash and auth_hash[:uid]
      return_url = clear_and_return_return_path
      user = User.find_or_create_by!(uid: auth_hash[:uid], email: auth_hash[:info][:email])
      set_current_user(user)
      redirect_to return_url
    else
      redirect_to root_url
    end
  end

  def destroy
    unset_current_user
    clear_and_return_return_path
    flash['success'] = 'Signed out!'
    redirect_to root_url
  end

  protected

  def clear_and_return_return_path
    return_url = session[:login_return_uri] || session[:login_return_referer] || root_path
    session[:login_return_uri] = session[:login_return_referer] = nil
    reset_session
    return_url
  end

  def shibboleth_login_path(host)
    "/Shibboleth.sso/Login?target=https://#{host}/auth/shibboleth/callback"
  end

end
