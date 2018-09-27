class Granite::Query::Builder(Model)
  getter page : Int64?
  getter per_page : Int64?

  def assembler
    Shale::Granite::Query::PGAssembler(Model).new self
  end

  def page(num)
    @page = num.to_i64

    self
  end

  def per(num)
    @per_page = num.to_i64

    self
  end

  def where(matches : Hash(Symbol | String, Symbol | String))
    matches.each do |field, data|
      @where_fields[field.to_s] = data
    end

    self
  end

  def order(dsl : Hash(Symbol | String, Symbol | String))
    dsl.each do |field, direction|
      direction = if direction == "desc" || direction == :desc
                    Sort::Descending
                  else
                    Sort::Ascending
                  end

      @order_fields << {field: field.to_s, direction: direction}
    end

    self
  end
end
