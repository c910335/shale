module Shale::Granite::Query::BuilderMethods
  include ::Granite::Query::BuilderMethods

  def __builder
    ::Granite::Query::Builder(self).new
  end

  delegate page, per, where, order, to: __builder
end
