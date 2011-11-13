class Admin::TagsController < Admin::BaseController
  def index
    tag = "#{params[:tag]}%"
    tags = ActsAsTaggableOn::Tag.where{ name =~ tag }
    render :json => tags.map(&:name)
  end
end
