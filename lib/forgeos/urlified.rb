module Forgeos
  module Urlified
    def self.included(base)
      base.before_validation :force_url_format, :generate_url
    end

    def force_url_format
      self.url = self.url.parameterize if self.url.present?
    end

    def generate_url
      return true if self.url.present?
      self.url = self.name.parameterize if self.name.present?
    end
  end
end
