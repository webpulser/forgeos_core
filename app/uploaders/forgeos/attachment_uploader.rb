# encoding: utf-8

module Forgeos
  class AttachmentUploader < CarrierWave::Uploader::Base
    include ::CarrierWave::MiniMagick
    include ::Sprockets::Helpers::RailsHelper
    include ::Sprockets::Helpers::IsolatedHelper
    include ::CarrierWave::Meta
    include ::CarrierWave::Backgrounder::Delay

    process :store_meta

    attr_accessor :filename

    def store_dir
      "uploads/#{model.class.to_s.underscore.split('/').last}/#{model.id}"
    end

    def default_url
      asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
    end

    def filename
      @filename ||= original_filename
    end
  end
end
