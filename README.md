# Fakeit

[![CircleCI](https://circleci.com/gh/JustinFeng/fakeit.svg?style=svg)](https://circleci.com/gh/JustinFeng/fakeit)

Create mock server from Openapi specification

## Description

* Randomly generated response
* Request validation
* Load specification from local or remote
* Support specification in yaml or json format

**Note:** Only support json content type as of now

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fakeit'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fakeit

## Usage

    $ fakeit --spec http://url/to/spec

Command line options:

    $ fakeit --help
    usage:
        --spec         spec file uri (required)
        -p, --port     custom port
        -q, --quiet    mute request and response log

    other options:
        -v, --version
        -h, --help

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/JustinFeng/fakeit.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
