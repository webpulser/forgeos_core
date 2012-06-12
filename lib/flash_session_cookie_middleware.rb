require 'rack/utils'

class FlashSessionCookieMiddleware
  def initialize(app, session_key = Rails.application.config.session_options[:key])
    @app = app
    @session_key = session_key
  end

  def call(env)
    if env['HTTP_USER_AGENT'] =~ /^(Adobe|Shockwave) Flash/

      req = Rack::Request.new(env)
      unless req.params[@session_key].nil?
        env['HTTP_COOKIE'] = "#{@session_key}=#{req.params[@session_key].gsub(' ','%2B')}".freeze
      end
    end

    @app.call(env)
  end
end
