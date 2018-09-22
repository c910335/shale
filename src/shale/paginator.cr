module Shale::Paginator(Adapter)
  @@shale_base_url : String?
  @@shale_path : String?

  def paginate(model)
    adapter = Adapter.new
    yield adapter

    count = adapter.count model
    adapter.headers.try &.add "Link", shale_header_links(adapter, count)
    adapter.select model
  end

  def shale_header_links(adapter, count)
    last_page = count / adapter.per
    last_page += 1 unless count % adapter.per == 0

    links = [] of String
    links << "<#{shale_full_url}?#{shale_page_params(adapter, adapter.page - 1)}>; rel=\"prev\"" if adapter.page > 1
    links << "<#{shale_full_url}?#{shale_page_params(adapter, adapter.page + 1)}>; rel=\"next\"" if adapter.page < last_page
    links << "<#{shale_full_url}?#{shale_page_params(adapter, 1)}>; rel=\"first\""
    links << "<#{shale_full_url}?#{shale_page_params(adapter, last_page)}>; rel=\"last\""
    links
  end

  def shale_page_params(adapter, page)
    HTTP::Params.build do |f|
      f.add "page", page.to_s
      f.add "per_page", adapter.per.to_s
      f.add "sort", adapter.order.to_s
      f.add "direction", adapter.direction.to_s
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
    def self.shale_base_url(@@shale_base_url : String)
    end

    def self.shale_path(@@shale_path : String)
    end
  end
end
