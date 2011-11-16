module Forgeos
  class Media < Attachment
    has_attachment self.options_for('media')
    validates_as_attachment
  end
end
