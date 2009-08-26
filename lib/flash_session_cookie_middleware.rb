require 'rack/utils'

class FlashSessionCookieMiddleware
  def initialize(app, session_key = ActionController::Base.session_options[:key])
    @app = app
    @session_key = session_key
  end

#  def call(env)
#    if env['HTTP_USER_AGENT'] =~ /^(Adobe|Shockwave) Flash/
#      params = env["rack.request.form_hash"]
#      unless params[@session_key].nil?
#        env['HTTP_COOKIE'] = [ @session_key, params[@session_key].gsub(' ','%2B') ].join('=').freeze
#      end
#    end
#    @app.call(env)
#  end

  def call(env)
      if env['HTTP_USER_AGENT'] =~ /^(Adobe|Shockwave) Flash/
        params = Rack::Request.new(env)

        unless params[@session_key].nil?
          env['HTTP_COOKIE'] = [ @session_key, params[@session_key].gsub(' ','%2B') ].join('=').freeze
        end
      end
      @app.call(env)
  end

end
