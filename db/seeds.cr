require "granite"
require "../spec/granite/config"
require "../spec/models/*"

unless Test.first
  10.times do |num|
    Test.create(num: num.to_i64)
  end
end
