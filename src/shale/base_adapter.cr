abstract class Shale::BaseAdapter
  getter headers : HTTP::Headers?

  @bundle : Bundle
  @page : Int32?
  @per : Int32?
  @order : String | Symbol | Nil
  @direction : String | Symbol | Nil
  @base_url : String?
  @path : String?

  def initialize(@bundle)
  end

  {% for prop in %i(page per order direction base_url path) %}
    def {{prop.id}}(@{{prop.id}})
    end

    def {{prop.id}}
      @{{prop.id}} || @bundle.{{prop.id}} || Shale.{{prop.id}}
    end
  {% end %}

  def headers(@headers)
  end

  def full_url
    base_url + path
  end

  abstract def count(model)
  abstract def select(model)
end
