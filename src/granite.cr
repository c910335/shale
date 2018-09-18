require "granite"
require "./granite/**"

class Granite::Base
  macro inherited
    extend Shale::Granite::Query::BuilderMethods
  end
end
