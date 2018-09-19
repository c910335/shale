class Granite::Query::Builder(Model)
  getter page = 1_i64
  getter per_page = 8_i64

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

  def order(fields : Hash(Symbol | String, Symbol | String))
    fields.each do |field, direction|
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
