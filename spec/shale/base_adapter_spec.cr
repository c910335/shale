require "./spec_helper"

def create_bundle
  Shale::Bundle.new(
    page: 7,
    per: 8,
    order: "9",
    direction: "10",
    base_url: "11",
    path: "12"
  )
end

def create_nil_bundle
  Shale::Bundle.new(
    page: nil,
    per: nil,
    order: nil,
    direction: nil,
    base_url: nil,
    path: nil
  )
end

describe Shale::BaseAdapter do
  it "chooses its properties first" do
    Shale.base_url = "https://base.url"
    adapter = Shale::Granite::Adapter.new(create_bundle)
    adapter.page 1
    adapter.per 2
    adapter.order "3"
    adapter.direction "4"
    adapter.base_url "5"
    adapter.path "6"

    adapter.page.should eq 1
    adapter.per.should eq 2
    adapter.order.should eq "3"
    adapter.direction.should eq "4"
    adapter.base_url.should eq "5"
    adapter.path.should eq "6"
  end

  it "chooses paginator's properties second" do
    Shale.base_url = "https://base.url"
    adapter = Shale::Granite::Adapter.new(create_bundle)

    adapter.page.should eq 7
    adapter.per.should eq 8
    adapter.order.should eq "9"
    adapter.direction.should eq "10"
    adapter.base_url.should eq "11"
    adapter.path.should eq "12"
  end

  it "chooses Shale's properties as defaults" do
    Shale.base_url = "https://base.url"
    adapter = Shale::Granite::Adapter.new(create_nil_bundle)

    adapter.page.should eq 1
    adapter.per.should eq 8
    adapter.order.should eq :id
    adapter.direction.should eq :desc
    adapter.base_url.should eq "https://base.url"
    adapter.path.should eq ""
  end
end
