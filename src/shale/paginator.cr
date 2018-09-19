module Shale::Paginator
  def paginate(model)
    builder = Builder.new
    yield builder
    model
      .page(builder.page)
      .per(builder.per)
      .order({builder.order => builder.direction})
      .select
  end

  class Builder
    getter page = 1_i64
    getter per = 8_i64
    getter order = :id
    getter direction = :desc

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
  end
end
