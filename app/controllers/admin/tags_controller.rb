class Admin::TagsController < Admin::BaseController

  def tag
    tags = ActsAsTaggableOn::Tag.find(:all,:conditions => ['name like ? ',"#{params[:tag]}%"])
    if tags.nil? || tags.blank? 
      render :json => ""
    else
      p tags.inspect
      tab = []
      tags.each do |tag|
        tab << tag.name
      end
    render :json => tab
    end
  end
end