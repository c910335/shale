require "./spec_helper"
include Shale::Paginator

describe Shale::Paginator do
  it "paginates model" do
    tests = paginate Test do |p|
      p.page 3
      p.per 3
      p.order :num
      p.direction :asc
    end

    tests.size.should eq 3
    tests.each_with_index do |test, i|
      test.num.should eq(i + 6)
    end
  end
end
