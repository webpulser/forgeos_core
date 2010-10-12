class Admin::CachingsController < Admin::BaseController

  def index
    @files = []
    directory = Rails.configuration.action_controller.page_cache_directory
    get_file(directory)
  end

  def create
    if params[:commit] == t('caching.delete.all').capitalize

      files = params[:hidden_files]

      files.values.each do |file|
        unless File.delete(file)
          flash[:error] = t('caching.delete.failed').capitalize
          return redirect_to :action => 'index'
        end
      end

    else
      if files = params[:file]
        files.values.each do |file|
          unless File.delete(file)
            flash[:error] = t('caching.delete.failed').capitalize
            return redirect_to :action => 'index'
          end
        end
      else
        return redirect_to :action => 'index'
        flash[:error] = t('caching.delete.failed').capitalize
      end
    end
    flash[:success] = t('caching.delete.create').capitalize
    return redirect_to :action => 'index'
  end


private

  def get_file(directory)
    dir = Dir.new(directory)
    dir.each do |file|
      path = "#{directory}/#{file}"
      if File.directory?(path)
        @files.delete(path)
        unless file == '.' || file == '..'
          get_file(path)
        end
      else
        @files << [file, path]
      end
    end
  end

end