class Arel::Nodes::Concatenation < Arel::Nodes::InfixOperation

  def initialize left, right
    super(:"||", left, right)
  end
end

Arel::Visitors::SQLite.class_eval do
  alias :visit_Arel_Nodes_Concatenation :visit_Arel_Nodes_InfixOperation
end
