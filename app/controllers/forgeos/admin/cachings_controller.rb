module Forgeos
  class Admin::CachingsController < Admin::BaseController
    autoload :FileUtils, 'fileutils'

    def index
      respond_to do |wants|
        wants.html
        wants.json do
          if params[:id] == '0'
            @files = [Rails.configuration.action_controller.page_cache_directory, Rails.cache.cache_path]
          else
            get_files(params[:id])
          end
        end
      end
    end

    def create
      if params[:commit] == t('caching.delete.all').capitalize
        get_files(Rails.configuration.action_controller.page_cache_directory)
        get_files(Rails.cache.cache_path)
      else
        @files = params[:files]
      end

      if @files
        @files.each do |file|
          unless FileUtils.rm_rf(file)
            flash[:error] = t('caching.delete.failed').capitalize
          end
        end
      else
        flash[:error] = t('caching.no_files').capitalize
      end

      flash[:success] = t('caching.delete.create').capitalize
      return redirect_to([forgeos_core, :admin, :cachings])
    end


  private

    def get_files(directory)
      @files ||= []
      @files += Dir.glob("#{directory}/*")
    end

  end
end
