class Test < Granite::Base
  adapter pg
  table_name tests
  field num : Int64
  timestamps
end
