module Shale::Paginator(Adapter)
  property! shale_adapter : Adapter

  def paginate(model)
    @shale_adapter = Adapter.new shale_bundle
    yield shale_adapter

    count = shale_adapter.count model
    shale_adapter.headers.try &.add "Link", shale_header_links(count)
    shale_adapter.select model
  end

  def shale_header_links(count)
    last_page = count / shale_adapter.per
    last_page += 1 unless count % shale_adapter.per == 0

    links = [] of String
    links << "<#{shale_adapter.full_url}?#{shale_page_params(shale_adapter.page - 1)}>; rel=\"prev\"" if shale_adapter.page > 1
    links << "<#{shale_adapter.full_url}?#{shale_page_params(shale_adapter.page + 1)}>; rel=\"next\"" if shale_adapter.page < last_page
    links << "<#{shale_adapter.full_url}?#{shale_page_params(1)}>; rel=\"first\""
    links << "<#{shale_adapter.full_url}?#{shale_page_params(last_page)}>; rel=\"last\""
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

  macro __included
    {% if @type < Object %}
      class_getter! shale_page : Int32
      class_getter! shale_per : Int32
      class_getter! shale_order : String | Symbol
      class_getter! shale_direction : String | Symbol
      class_getter! shale_base_url : String
      class_getter! shale_path : String

      {% for prop in %i(page per order direction base_url path) %}
        def self.shale_{{prop.id}}(@@shale_{{prop.id}})
        end
      {% end %}

      def shale_bundle
        Shale::Bundle.new(
          {% for prop in %i(page per order direction base_url path) %}
            {{prop.id}}: @@shale_{{prop.id}},
          {% end %}
        )
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
