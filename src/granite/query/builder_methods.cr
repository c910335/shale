module Shale::Granite::Query::BuilderMethods
  include ::Granite::Query::BuilderMethods

  def __builder
    ::Granite::Query::Builder(self).new
  end

  def page(num)
    __builder.page(num)
  end
end
