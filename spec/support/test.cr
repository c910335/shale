class Test < Granite::Base
  connection pg
  table tests
  column id : Int64, primary: true
  column num : Int64
  timestamps
end
