require "granite"
require "./shale/base_adapter"
require "./granite/**"

class Granite::Base
  macro inherited
    extend Shale::Granite::Query::BuilderMethods
  end
end
