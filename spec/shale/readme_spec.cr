require "./spec_helper"

class ArrayAdapter < Shale::BaseAdapter
  def count(array)
    array.size
  end

  def select(array)
    sorted = if direction.to_s == "desc"
               array.sort { |a, b| b[order] <=> a[order] }
             else
               array.sort { |a, b| a[order] <=> b[order] }
             end
    sorted[(page - 1) * per, per]
  end
end

class ArrayPaginator
  include Shale::Paginator(ArrayAdapter)
end

describe "READMD.md" do
  describe ArrayAdapter do
    it "paginates an array" do
      array = Array.new(10) do |i|
        {:number => 10 - i}
      end

      paginated = ArrayPaginator.new.paginate array do |p|
        p.page 2
        p.per 3
        p.order :number
        p.direction :asc
      end

      paginated.should eq [
        {:number => 4},
        {:number => 5},
        {:number => 6},
      ]
    end
  end
end
