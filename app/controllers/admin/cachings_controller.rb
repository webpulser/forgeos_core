class Admin::CachingsController < Admin::BaseController
  autoload :FileUtils, 'fileutils'

  def index
    @files = []
    directory = Rails.configuration.action_controller.page_cache_directory
    if directory
      get_file(directory)
    end
  end

  def create
    if params[:commit] == t('caching.delete.all').capitalize
      files = params[:hidden_files]
    else
      files = params[:file]
    end

    if files
      files.values.each do |file|
        unless File.delete(file)
          flash[:error] = t('caching.delete.failed').capitalize
          return redirect_to :action => 'index'
        end
      end
    else
      return redirect_to :action => 'index'
      flash[:error] = t('caching.no_files').capitalize
    end


    begin
      FileUtils.remove_dir(Rails.cache.cache_path, true)
    rescue
      p 'This cache directory does not exist'
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