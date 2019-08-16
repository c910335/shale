class Shale::Granite::Adapter < Shale::BaseAdapter
  def count(model)
    c = model.count
    c = c.run unless c.is_a? Int
    raise "Workaround: unsupported multiple values" if c.is_a? Array
    c.to_i
  end

  def select(model)
    model
      .offset((page - 1) * per)
      .limit(per)
      .order({order => direction})
      .select
  end
end
