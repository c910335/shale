require "granite"
require "../spec/support/*"

unless Test.first
  10.times do |num|
    Test.create(num: num.to_i64)
  end
end
