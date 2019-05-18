# JsonApiTestHelpers

Collection of helper methods to easy testing of JSON API https://jsonapi.org/ responses

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json_api_test_helpers'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json_api_test_helpers

## Usage

Methods:

| Methods       | Params  | Description                                                             |
|---------------|---------|-------------------------------------------------------------------------|
| json_response |         | Returns parsed `response.body` as Hash with indifferent access or Array |
| json_api_record | `record`, `attributes`, `relationships: nil`, `additional: nil`| Returns Hash in JSON API format with serialized object |
| json_api_collection | `collection`, `attributes = nil`, `relationships: nil` | Returns Hash in JSON API format with serialized array |
| fix_value_for_json | `value` | Fix values which are usually used in Rails apps. `DateTime`, `ActiveSupport::TimeWithZone` to `iso8601`; `CarrierWave::Uploader::Serialization` to `serializable_hash`; everything else to Hash with replaced underscores `_` to minus `-` in attribute names |
| fix_comparing_types | `value` | Fix type value to easy compare. `DateTime`, `ActiveSupport::TimeWithZone` to `datetime` with UTC; `ActiveRecord::Point` to string `"#{value.x}, #{value.y}"`. |
| attributes_for_nested | `attributes`, `**associations` | Merge `attributes` with associations with JSON API format |

## Examples

```ruby
expect(json_response).to include_json(json_api_record(User.first))

expect(json_response).to include_json(json_api_collection(User.all))

expect(json_response).to include_json(json_api
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/json_api_test_helpers. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the JsonApiTestHelpers project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/json_api_test_helpers/blob/master/CODE_OF_CONDUCT.md).
