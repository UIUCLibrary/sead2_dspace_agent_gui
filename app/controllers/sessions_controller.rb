class SessionsController < ApplicationController

  # This is contained within omniauth.
  skip_before_action :verify_authenticity_token

  ##
  # Responds to POST /auth/:provider/callback
  #
  def create
    auth_hash = request.env['omniauth.auth']
    if auth_hash and auth_hash[:uid]
      # username = auth_hash[:uid].split('@').first
      user = User.find_or_create_by(uid: auth_hash[:uid], email: auth_hash[:info][:email])
      if user and user.enabled
        return_url = clear_and_return_return_path
        sign_in user
        #We can access other information via auth_hash[:extra][:raw_info][key]
        #where key is a string from config/shibboleth.yml (and of course these
        #have to correspond to passed attributes)
        redirect_to return_url
        return
      end
    end
    flash['error'] = 'Sign-in failed.'
    redirect_to root_url
  end

  def destroy
    sign_out
    redirect_to root_url
  end

  def new
    session[:referer] = request.env['HTTP_REFERER']
    if Rails.env.production?
      redirect_to(shibboleth_login_path(Sead2DspaceAgentGui::Application.shibboleth_host))
    else
      redirect_to('/auth/developer')
    end
  end

  protected

  def clear_and_return_return_path
    return_url = session[:return_to] || session[:referer] || admin_root_path
    session[:return_to] = session[:referer] = nil
    reset_session
    return_url
  end

  def shibboleth_login_path(host)
    "/Shibboleth.sso/Login?target=https://#{host}/auth/shibboleth/callback"
  end

end