module Forgeos
  module Urlified
    def self.included(base)
      base.before_save :force_url_format, :generate_url
    end

    def force_url_format
      self.url= Forgeos::url_generator(self.url)
    end

    def generate_url
      return true if self.url.present?
      self.url = self.name.parameterize if self.name.present?
    end
  end
end
