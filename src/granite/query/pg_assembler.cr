class Shale::Granite::Query::PGAssembler(Model) < Granite::Query::Assembler::Postgresql(Model)
  @numbered_parameters = [] of DB::Any
  @aggregate_fields = [] of String

  def initialize(@query : ::Granite::Query::Builder(Model))
  end

  def build_limit_offset
    if @query.page && @query.per_page
      "LIMIT #{@query.per_page} OFFSET #{@query.per_page.not_nil! * (@query.page.not_nil! - 1)}"
    else
      ""
    end
  end

  def count : ::Granite::Query::Executor::Value(Model, Int64)
    sql = <<-SQL
      SELECT COUNT(*)
      FROM #{table_name}
      #{build_where}
      #{build_group_by}
      #{build_order false}
      #{build_limit_offset}
    SQL

    ::Granite::Query::Executor::Value(Model, Int64).new sql, numbered_parameters, default: 0_i64
  end

  def select : ::Granite::Query::Executor::List(Model)
    sql = <<-SQL
      SELECT #{field_list}
      FROM #{table_name}
      #{build_where}
      #{build_order}
      #{build_limit_offset}
    SQL

    ::Granite::Query::Executor::List(Model).new sql, numbered_parameters
  end
end
