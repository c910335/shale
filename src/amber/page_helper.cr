module Shale::Amber::PageHelper(Adapter)
  include Shale::Paginator(Adapter)

  def paginate(model)
    paginate model do |p|
      p.path request.path
      p.page params["page"] if params["page"]?
      p.per params["per_page"] if params["per_page"]?
      p.order params["sort"] if params["sort"]?
      p.direction params["direction"] if params["direction"]?
      p.headers response.headers
    end
  end
end
