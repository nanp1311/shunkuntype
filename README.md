# Shunkuntype

Touch type習得アプリ．Touch type mastering application.  

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shunkuntype'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shunkuntype

現在のところ一般公開ではなく，下記のサイトにclosedで置いている．そこからdown loadするには
あらかじめgemにserver addressを登録しておく必要がある．さらに関学のネットからのアクセスには
proxyを通しておく必要がある．
```tcsh
bob% setenv HTTP_PROXY http://proxy.ksc.kwansei.ac.jp:8080
bob% setenv HTTPS_PROXY http://proxy.ksc.kwansei.ac.jp:8080
bob% gem source -a 'http://nishitani0.kwansei.ac.jp/~bob/nishitani0/gems/' 
http://nishitani0.kwansei.ac.jp/~bob/nishitani0/gems/ added to sources
bob% gem search shunkuntype -r
for bash, zsh
bob% export HTTP_PROXY=http://proxy.ksc.kwansei.ac.jp:8080
bob% export  HTTPS_PROXY=http://proxy.ksc.kwansei.ac.jp:8080
```

## Usage

```ruby
Usage: shunkuntype [options]
    -v, --version                    Show program version.
    -i, --init                       initialize data files.
    -s, --speed                      speed check.
    -m, --minute [VAL]               minute training of file Integer.
    -h, --history                    view training history.
    -r, --report                     submit data to dmz0
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/shunkuntype. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

