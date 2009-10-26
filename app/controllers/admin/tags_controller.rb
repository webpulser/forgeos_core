class Admin::TagsController < Admin::BaseController

  def tag
    tags = Tag.find(:all,:conditions => ['name like ? ',"#{params[:tag]}%"])
    if tags.nil?
      render :text => '' 
    else
      render :text =>  tags.first.name 
    end
  end

end