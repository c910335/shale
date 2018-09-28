# Shale

[![Build Status](https://travis-ci.com/c910335/shale.svg?branch=master)](https://travis-ci.com/c910335/shale)
[![GitHub releases](https://img.shields.io/github/release/c910335/shale.svg)](https://github.com/c910335/shale/releases)
[![GitHub license](https://img.shields.io/github/license/c910335/shale.svg)](https://github.com/c910335/shale/blob/master/LICENSE)

Paginator for [Amber Framework](https://github.com/amberframework/amber)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  shale:
    github: c910335/shale
```

## Usage

Note: Shale only supports [Granite](https://github.com/amberframework/granite) and PostgreSQL currently.

```crystal

# config/initializers/paginator.cr
require "shale/amber" # for page helper
require "shale/granite" # for granite adapter
Shale.base_url = "https://base.url"

# src/controllers/application_controller.cr
class ApplicationController < Amber::Controller::Base
  include Shale::Amber::PageHelper(Shale::Granite::Adapter)
end

# src/controller/sample_controller
class SampleController < ApplicationController
  def index
    samples = paginate Sample
    # render your view with samples
  end
end
```

`Shale::Amber::PageHelper#paginate` reads parameters from `params` and path from `request.path` and adds links to `response.headers`, then returns the paginated data.

### Parameters

| name | type | required | default | value |
|:-:|:-:|:-:|:-:|:-:|
| page | number | false | 1 |
| per_page | number | false | 8 |
| sort | string | false | `id` | must be one of the columns |
| direction | string | false | `desc` | `asc` or `desc` |

### Response Header

reference: [RFC 5988 - Web Linking](https://tools.ietf.org/html/rfc5988)

```
Link: <https://base.url/samples?page=2&per_page=3&sort=id&direction=desc>; rel="prev",
  <https://base.url/samples?page=4&per_page=3&sort=id&direction=desc>; rel="next",
  <https://base.url/samples?page=1&per_page=3&sort=id&direction=desc>; rel="first",
  <https://base.url/samples?page=8&per_page=3&sort=id&direction=desc>; rel="last"
```

### Default Values

```crystal
# Global
Shale.base_url = "https://base.url" # required
Shale.path = "/path"
Shale.page = 1
Shale.per = 8
Shale.order = :id
Shale.direction = :desc

# Scoped
class SomeController
  include Shale::Amber::PageHelper(Shale::Granite::Adapter)

  shale_base_url = "https://base.url"
  Shale_path = "/path"
  shale_page = 1
  shale_per = 8
  shale_order = :id
  shale_direction = :desc
end
```

## Customization

### Paginator

This is what `Shale::Amber::PageHelper` looks like.

```crystal
require "shale"

module Shale::Amber::PageHelper(Adapter)
  include Shale::Paginator(Adapter)

  def paginate(model)
    paginate model do |p|
      p.path request.path
      p.page params["page"].to_i if params["page"]?
      p.per params["per_page"].to_i if params["per_page"]?
      p.order params["sort"] if params["sort"]?
      p.direction params["direction"] if params["direction"]?
      p.headers response.headers
    end
  end
end
```

You can change the source of path or parameters by building your own paginator.

### Adapter

- inherits `Shale::BaseAdapter`
- implements `#count(model)` and `#select(model)` with `#page`, `#per`, `#order` and `#direction`

For example, this is an `ArrayAdapter`.

```crystal
require "shale"

class ArrayAdapter < Shale::BaseAdapter
  def count(array)
    array.size
  end

  def select(array)
    sorted = if direction.to_s == "desc"
               array.sort { |a, b| b[order] <=> a[order] }
             else
               array.sort { |a, b| a[order] <=> b[order] }
             end
    sorted[(page - 1) * per, per]
  end
end
```

Which is useful to paginate `Array(Hash(Symbol, Int32))`.

```crystal
class ArrayPaginator
  include Shale::Paginator(ArrayAdapter)
end

array = Array.new(10) do |i|
  {:number => 10 - i}
end

paginated = ArrayPaginator.new.paginate array do |p|
  p.page 2
  p.per 3
  p.order :number
  p.direction :asc
end

pp paginated # => [{:number => 4}, {:number => 5}, {:number => 6}]
```

## Development

Since Shale depends on PostgreSQL, we run specs with Docker.

```
$ docker-compose build
$ docker-compose run migrate
$ docker-compose run spec
```

## Contributing

1. Fork it (<https://github.com/c910335/shale/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [c910335](https://github.com/c910335) Tatsiujin Chin - creator, maintainer
