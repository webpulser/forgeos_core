class Admin::AccountController < Admin::BaseController

  # GET /account
  # GET /account.xml
  def index
    redirect_to(admin_account_path(self.current_user))
  end

  # GET /account/1
  # GET /account/1.xml
  def show
    @user = self.current_user
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @user }
#    end
  end

  # GET /account/1/edit
  def edit
    @user = self.current_user
  end

  # PUT /account/1
  # PUT /account/1.xml
  def update
    @user = self.current_user
    respond_to do |format|
      if @user.update_attributes(params[:account])
        flash[:notice] = I18n.t('my_account.update.success').capitalize
        format.html { redirect_to(admin_account_path(@user)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /account/1
  # DELETE /account/1.xml
  def destroy
    @user = self.current_user
    logout_killing_session!
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(new_admin_session_path) }
      format.xml  { head :ok }
    end
  end
end
