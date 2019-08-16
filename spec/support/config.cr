require "granite/adapter/pg"

Granite::Connections << Granite::Adapter::Pg.new(name: "pg", url: ENV["DATABASE_URL"]? || "postgres://postgres:@localhost:5432/test")
