module Forgeos
  class Medium < Attachment
    has_attachment self.options_for('medium')
    validates_as_attachment
  end
end
