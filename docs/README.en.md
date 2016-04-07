# Shunkuntype

touch typing習得をめざしたcommand line interface アプリ．Touch type mastering application.  

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shunkuntype'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install shunkuntype
```

## Usage

```ruby
Usage: shunkuntype [options]
    -v, --version                    show program Version.
    -c, --check                      Check speed
    -d, --drill [VAL]                one minute Drill [VAL]
    -h, --history                    view training History
    -p, --plot                       Plot personal data
    -s, --submit                     Submit data to dmz0
        --review [VALUE]             Review training, VALUE=html or hiki
```

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/daddygongon/shunkuntype. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
