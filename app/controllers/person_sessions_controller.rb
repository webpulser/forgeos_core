class PersonSessionsController < ApplicationController
  def new
    @person_session = PersonSession.new
  end

  def create
    @person_session = PersonSession.new(params[:person_session])
    if @person_session.save
      redirect_to_stored_location(:root)
      flash[:notice] = t('log.in.success').capitalize
    else
      flash[:error] = t('log.in.failed').capitalize
      redirect_to_stored_location([forgeos_core, :login])
    end
  end

  def destroy
    if current_user_session and current_user_session.destroy
      flash[:notice] = I18n.t('log.out.success').capitalize
    end
    redirect_to(:root)
  end
end
