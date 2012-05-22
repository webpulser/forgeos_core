module Forgeos
  class Admin::AccountsController < Admin::BaseController

    before_filter :get_account, :except => [:index]

    def index
      redirect_to([forgeos_core, :admin, :account])
    end

    def show; end

    def edit; end

    def update
      if @user.update_attributes(params[:administrator])
        flash[:notice] = t('my_account.update.success').capitalize
      end
      render :action => 'edit'
    end

    private

    def get_account
      @user = current_user
    end
  end
end
