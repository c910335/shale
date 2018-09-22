abstract class Shale::BaseAdapter
  getter page = 1_i64
  getter per = 8_i64
  getter order : String | Symbol = :id
  getter direction : String | Symbol = :desc
  getter headers : HTTP::Headers?

  def page(num)
    @page = num.to_i64
  end

  def per(num)
    @per = num.to_i64
  end

  def order(@order)
  end

  def direction(@direction)
  end

  def headers(@headers)
  end

  abstract def count(model)
  abstract def select(model)
end
