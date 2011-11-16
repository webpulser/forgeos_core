module Forgeos
  class Doc < Attachment
    has_attachment self.options_for('doc')
    validates_as_attachment
  end
end
