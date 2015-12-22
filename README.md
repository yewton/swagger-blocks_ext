# Swagger::BlocksExt

Some extensions to [swagger-blocks](https://github.com/fotinakis/swagger-blocks "swagger-blocks").

1. Enable to find all `Swagger::Blocks` instances from `ObjectSpace` then output the spec
1. Enable to edit descriptions in separate files(to edit it with your favorite Markdown editor)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'swagger-blocks_ext'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install swagger-blocks_ext

## Usage

```ruby
require 'swagger/blocks_ext'
require '/path/to/your/swagger-blocks/root'

Swagger::BlocksExt.configure do |c|
  c.descriptions_path = File.join(__dir__, 'descriptions') # where to put your descriptions file
end

class Root
  include Swagger::Blocks
  using Swagger::BlocksExt::NodeExt

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Swagger Petstore'
      key :description, md('introduction') + "\n\n" + md(ENV['RAILS_ENV'])
      key :termsOfService, 'http://swagger.io/terms/'
    end
    key :host, 'petstore.swagger.io'
    key :basePath, '/api'
    key :schemes, ['http']
  end
end

File.open(path, 'w') {|f| f.write(Swagger::BlocksExt.to_yaml) }
```

### Docker

```sh
docker run --rm \
       -v /path/to/your/swagger-blocks/:/blocks \
       -v /path/to/your/descriptions:/descriptions \
       -v /path/to/out:/out \
       yewton/swagger-blocks_ext \
       swagger:gen[/out/swagger.yaml,/blocks/root,/descriptions]
```

What happens?

1. require `/path/to/your/swagger-blocks/root.rb`
1. set descriptions directory configuration to `/path/to/your/descriptions`
1. generated swagger spec is in `/path/to/out`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yewton/swagger-blocks_ext.

