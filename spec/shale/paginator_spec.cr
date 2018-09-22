require "./spec_helper"

class TestController
  include Shale::Granite::Paginator

  def tests
    paginate Test do |p|
      p.page 3
      p.per 3
      p.order :num
      p.direction :asc
    end
  end

  def tests(headers)
    paginate Test do |p|
      p.page 3
      p.per 2
      p.headers headers
    end
  end
end

class ScopedTestController
  include Shale::Granite::Paginator
  shale_base_url "https://scoped.base.url"
  shale_path "/other_tests"

  def tests(headers)
    paginate Test do |p|
      p.page 1
      p.per 3
      p.headers headers
    end
  end
end

describe Shale::Paginator do
  it "paginates model" do
    tests = TestController.new.tests

    tests.size.should eq 3
    tests.each_with_index do |test, i|
      test.num.should eq(i + 6)
    end
  end

  it "paginates model and provides link header" do
    Shale.base_url = "https://base.url"
    Shale.path = "/tests"
    headers = HTTP::Headers.new
    tests = TestController.new.tests headers

    tests.size.should eq 2
    tests.each_with_index do |test, i|
      test.num.should eq(5 - i)
    end
    headers["Link"]?.should eq(
      [
        %(<https://base.url/tests?page=2&per_page=2&sort=id&direction=desc>; rel="prev"),
        %(<https://base.url/tests?page=4&per_page=2&sort=id&direction=desc>; rel="next"),
        %(<https://base.url/tests?page=1&per_page=2&sort=id&direction=desc>; rel="first"),
        %(<https://base.url/tests?page=5&per_page=2&sort=id&direction=desc>; rel="last"),
      ].join(',')
    )
  end

  it "paginates model and provides link header with scoped url" do
    Shale.base_url = "https://base.url"
    Shale.path = "/tests"
    headers = HTTP::Headers.new
    tests = ScopedTestController.new.tests headers

    tests.size.should eq 3
    tests.each_with_index do |test, i|
      test.num.should eq(9 - i)
    end
    headers["Link"]?.should eq(
      [
        %(<https://scoped.base.url/other_tests?page=2&per_page=3&sort=id&direction=desc>; rel="next"),
        %(<https://scoped.base.url/other_tests?page=1&per_page=3&sort=id&direction=desc>; rel="first"),
        %(<https://scoped.base.url/other_tests?page=4&per_page=3&sort=id&direction=desc>; rel="last"),
      ].join(',')
    )
  end
end
