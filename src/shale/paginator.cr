module Shale::Paginator
  @@shale_base_url : String?
  @@shale_path : String?

  def paginate(model)
    builder = Builder.new
    yield builder

    count = model.count.run
    builder.headers.try &.add "Link", shale_header_links(builder, count)
    model
      .page(builder.page)
      .per(builder.per)
      .order({builder.order => builder.direction})
      .select
  end

  def shale_header_links(builder, count)
    last_page = count / builder.per
    last_page += 1 unless count % builder.per == 0

    links = [] of String
    links << "<#{shale_full_url}?#{shale_page_params(builder, builder.page - 1)}>; rel=\"prev\"" if builder.page > 1
    links << "<#{shale_full_url}?#{shale_page_params(builder, builder.page + 1)}>; rel=\"next\"" if builder.page < last_page
    links << "<#{shale_full_url}?#{shale_page_params(builder, 1)}>; rel=\"first\""
    links << "<#{shale_full_url}?#{shale_page_params(builder, last_page)}>; rel=\"last\""
    links
  end

  def shale_page_params(builder, page)
    HTTP::Params.build do |f|
      f.add "page", page.to_s
      f.add "per_page", builder.per.to_s
      f.add "sort", builder.order.to_s
      f.add "direction", builder.direction.to_s
    end
  end

  def shale_full_url
    shale_base_url + shale_path
  end

  def shale_base_url
    @@shale_base_url || Shale.base_url
  end

  def shale_path
    @@shale_path || Shale.path
  end

  macro included
    def self.shale_base_url(@@shale_base_url)
    end

    def self.shale_path(@@shale_path)
    end
  end

  class Builder
    getter page = 1_i64
    getter per = 8_i64
    getter order = :id
    getter direction = :desc
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
  end
end
