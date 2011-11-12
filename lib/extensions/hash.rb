# add persisted? method for using serialized attributes in form_builders
Hash.class_eval do
  def persisted?
    false
  end
end
