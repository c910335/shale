require "http/headers"
require "http/params"
require "./shale/*"

module Shale
  class_property! base_url : String
  class_property path : String = ""
end
