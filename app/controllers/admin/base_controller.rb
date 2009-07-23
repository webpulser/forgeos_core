class Admin::BaseController < ApplicationController
  include AuthenticatedSystem
  layout 'admin'
  before_filter :login_required
end
