class Shale::Granite::Adapter < Shale::BaseAdapter
  def count(model)
    model.count.to_i
  end

  def select(model)
    model
      .offset((page - 1) * per)
      .limit(per)
      .order({order => direction})
      .select
  end
end
