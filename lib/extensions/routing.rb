module ActionDispatch
  module Routing
    class Mapper
      module Base
        private
          def define_generate_prefix(app, name)
            return unless app.respond_to?(:routes) && app.routes.respond_to?(:define_mounted_helper)

            _route = @set.named_routes.routes[name.to_sym]
            _routes = @set
            app.routes.define_mounted_helper(name)
            app.routes.class_eval do
              define_method :_generate_prefix do |options|
                prefix_options = options.slice(*_route.segment_keys)
                # we must actually delete prefix segment keys to avoid passing them to next url_for
                _route.segment_keys.each { |k| options.delete(k) }
                mount_path = _routes.url_helpers.send("#{name}_path", prefix_options)
                mount_path == '/' ? '' : mount_path
              end
            end
          end

      end
    end
  end
end
