require "http/headers"
require "http/params"
require "./shale/*"

module Shale
  class_property! base_url : String
  class_property path : String = ""
  class_property page = 1
  class_property per = 8
  class_property order = :id
  class_property direction = :desc
end
