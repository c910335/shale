require "./spec_helper"

record Request, path : String
record Response, headers : HTTP::Headers

module PageHelper
  include Shale::Amber::PageHelper(Shale::Granite::Adapter)
end

class AmberTestController
  include PageHelper

  getter params = {
    "page"      => "2",
    "per_page"  => "2",
    "sort"      => "num",
    "direction" => "asc",
  }
  getter request = Request.new(path: "/amber_tests")
  getter response = Response.new(headers: HTTP::Headers.new)

  def tests
    paginate Test
  end

  def even_tests
    paginate Test.where({"num % 2" => "0"})
  end
end

describe Shale::Amber::PageHelper do
  it "paginates model automatically" do
    Shale.base_url = "https://base.url"
    controller = AmberTestController.new
    tests = controller.tests

    tests.size.should eq 2
    tests.each_with_index do |test, i|
      test.num.should eq(i + 2)
    end
    controller.response.headers["Link"]?.should eq(
      [
        %(<https://base.url/amber_tests?page=1&per_page=2&sort=num&direction=asc>; rel="prev"),
        %(<https://base.url/amber_tests?page=3&per_page=2&sort=num&direction=asc>; rel="next"),
        %(<https://base.url/amber_tests?page=1&per_page=2&sort=num&direction=asc>; rel="first"),
        %(<https://base.url/amber_tests?page=5&per_page=2&sort=num&direction=asc>; rel="last"),
      ].join(',')
    )
  end

  it "paginates model with where automatically" do
    Shale.base_url = "https://base.url"
    controller = AmberTestController.new
    tests = controller.even_tests

    tests.size.should eq 2
    tests.each_with_index do |test, i|
      test.num.should eq(i * 2 + 4)
    end
    controller.response.headers["Link"]?.should eq(
      [
        %(<https://base.url/amber_tests?page=1&per_page=2&sort=num&direction=asc>; rel="prev"),
        %(<https://base.url/amber_tests?page=3&per_page=2&sort=num&direction=asc>; rel="next"),
        %(<https://base.url/amber_tests?page=1&per_page=2&sort=num&direction=asc>; rel="first"),
        %(<https://base.url/amber_tests?page=3&per_page=2&sort=num&direction=asc>; rel="last"),
      ].join(',')
    )
  end
end
