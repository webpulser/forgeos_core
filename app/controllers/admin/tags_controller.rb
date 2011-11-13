class Admin::TagsController < Admin::BaseController
  def create
    unless tags = ActsAsTaggableOn::Tag.find(:all,:conditions => ['name like ? ',"#{params[:tag]}%"])
      render :json => nil
    else
      render :json => tags.map(&:name)
    end
  end
end
