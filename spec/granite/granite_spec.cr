require "./spec_helper"

describe Shale::Granite::Query::PGAssembler do
  it "builds limit and offset" do
    Test.page(10).per(8).raw_sql.chomp.split
      .should eq %w(SELECT id, num, created_at, updated_at FROM tests ORDER BY id DESC LIMIT 8 OFFSET 72)
  end

  it "selects with limit and offset" do
    tests = Test.page(3).per(3).select

    tests.size.should eq(3)
    tests.each_with_index do |test, i|
      test.num.should eq(3 - i)
    end
  end
end
