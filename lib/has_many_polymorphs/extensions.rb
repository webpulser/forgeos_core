module ActiveRecord
  module Associations

    class PolymorphicAssociation < HasManyThroughAssociation
      def replace(*records)
        self.clear 
        self.<<(records)
      end
    end

    module PolymorphicClassMethods
      def has_many_polymorphs_with_accessor(association_id, options = {}, &extension)
        _logger_debug "associating #{self}.#{association_id}"
        reflection = create_has_many_polymorphs_reflection(association_id, options, &extension)
        # puts "Created reflection #{reflection.inspect}"
        # configure_dependency_for_has_many(reflection)
        collection_accessor_methods(reflection, PolymorphicAssociation)
      end
      
      alias_method_chain :has_many_polymorphs, :accessor

      def collection_accessor_methods(reflection, association_proxy_class, writer = true)
        collection_reader_method(reflection, association_proxy_class)
        if writer
          define_method("#{reflection.name}=") do |new_value|
            # Loads proxy class instance (defined in collection_reader_method) if not already loaded
            association = send(reflection.name)
            association.replace(new_value)
            association
          end

          define_method("#{reflection.name.to_s.singularize}_ids=") do |new_value|
            ids = (new_value || []).reject { |nid| nid.blank? }
            
            models = []
            reflection.options[:from].each do |klass|
              models += klass.to_s.singularize.camelize.constantize.find_all_by_id(ids)
            end unless ids.empty? && reflection.options[:from]
            
            send("#{reflection.name}=", models)
          end
        end
      end
    end
  end
end
