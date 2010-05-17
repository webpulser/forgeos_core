class ImportSet < ActiveRecord::Base
  serialize :fields
  serialize :parser_options
end
