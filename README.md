# ValvatCache

ValvatCache is a simple cache for Valvat (https://github.com/yolk/valvat_cache)

## Installation

Add this lines to your application's Gemfile:

```ruby
gem 'valvat'
gem 'valvat_cache'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install valvat_cache

## Usage

```ruby
Valvat::Lookup.expiration_days = 7 # Optional, defaults to 7
Valvat::Lookup.cache_path = 'path/to/cache/file.json'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/valvat_cache. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

