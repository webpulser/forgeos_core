task :model_translations, [:model] => :environment do |t,args|
  klass = args.model.camelize.constantize
  puts klass
  klass.all.each do |model|
    attributes = {}
    model.translated_attributes.keys.each do |method|
      attributes[method] = model.attributes[method.to_s]
    end
    if model.update_attributes(attributes)
      puts "translated #{model.id}"
    else
      puts model.errors.inspect
    end
  end
end
