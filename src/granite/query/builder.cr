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
end
