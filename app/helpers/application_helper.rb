# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include Forgeos::MenuHelper
  include Forgeos::AttachmentHelper
  include Forgeos::SerializedFieldHelper
  include Forgeos::StatisticsHelper
end
