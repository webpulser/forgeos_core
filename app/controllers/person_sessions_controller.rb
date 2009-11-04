# This controller handles the login/logout function of the site.  
class PersonSessionsController < ApplicationController
  def new
    @person_session = PersonSession.new
  end

  def create
    @person_session = PersonSession.new(params[:person_session])
    if @person_session.save
      if redirect = session[:return_to]
        session[:return_to] = nil
        redirect_to(redirect)
      else
        redirect_to(:root)
      end
      flash[:notice] = t('log.in.success').capitalize
    else
      flash[:error] = t('log.in.failed').capitalize
      if redirect = session[:return_to]
        session[:return_to] = nil
        redirect_to(redirect)
      else
        redirect_to :action => 'new'
      end
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = I18n.t('log.out.success').capitalize
    redirect_to(:root)
  end
end
