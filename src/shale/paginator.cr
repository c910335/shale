module Shale::Paginator(Adapter)
  property! shale_adapter : Adapter

  def paginate(model)
    @shale_adapter = Adapter.new
    yield shale_adapter

    count = shale_adapter.count model
    shale_adapter.headers.try &.add "Link", shale_header_links(count)
    shale_adapter.select model
  end

  def shale_header_links(count)
    last_page = count / shale_adapter.per
    last_page += 1 unless count % shale_adapter.per == 0

    links = [] of String
    links << "<#{shale_full_url}?#{shale_page_params(shale_adapter.page - 1)}>; rel=\"prev\"" if shale_adapter.page > 1
    links << "<#{shale_full_url}?#{shale_page_params(shale_adapter.page + 1)}>; rel=\"next\"" if shale_adapter.page < last_page
    links << "<#{shale_full_url}?#{shale_page_params(1)}>; rel=\"first\""
    links << "<#{shale_full_url}?#{shale_page_params(last_page)}>; rel=\"last\""
    links
  end

  def shale_page_params(page)
    HTTP::Params.build do |f|
      f.add "page", page.to_s
      f.add "per_page", shale_adapter.per.to_s
      f.add "sort", shale_adapter.order.to_s
      f.add "direction", shale_adapter.direction.to_s
    end
  end

  def shale_full_url
    shale_base_url + shale_path
  end

  def shale_base_url
    @@shale_base_url || Shale.base_url
  end

  def shale_path
    shale_adapter.path || @@shale_path || Shale.path
  end

  macro __included
    {% if @type < Object %}
      def self.shale_base_url(@@shale_base_url : String)
      end

      def self.shale_path(@@shale_path : String)
      end
    {% else %}
      macro included
        __included
      end
    {% end %}
  end

  macro included
    __included
  end
end
