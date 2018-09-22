# Shale

Paginator for [Amber Framework](https://github.com/amberframework/amber)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  shale:
    github: c910335/shale
```

## Usage

Note: Shale only supports Granite and PostgreSQL currently.

```crystal
# config/application.cr
require "shale/granite" # for granite adapter
require "shale/amber" # for page helper

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

`Shale::Amber::PageHelper#paginate` reads parameters from `params` and adds links to `response.headers` automatically.

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
Link: <https://base.url/tests?page=2&per_page=3&sort=id&direction=desc>; rel="prev",
  <https://base.url/tests?page=4&per_page=3&sort=id&direction=desc>; rel="next",
  <https://base.url/tests?page=1&per_page=3&sort=id&direction=desc>; rel="first",
  <https://base.url/tests?page=8&per_page=3&sort=id&direction=desc>; rel="last"
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
