class Shale::Granite::Adapter < Shale::BaseAdapter
  def count(model)
    model.count.run
  end

  def select(model)
    model
      .page(page)
      .per(per)
      .order({order => direction})
      .select
  end
end
