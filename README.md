# Fakeit

[![CircleCI](https://img.shields.io/circleci/build/github/JustinFeng/fakeit.svg)](https://circleci.com/gh/JustinFeng/fakeit)
[![Code Climate maintainability](https://img.shields.io/codeclimate/maintainability/JustinFeng/fakeit.svg)](https://codeclimate.com/github/JustinFeng/fakeit)
[![Gem](https://img.shields.io/gem/v/fakeit.svg)](https://rubygems.org/gems/fakeit)
[![Gem](https://img.shields.io/gem/dt/fakeit.svg)](https://rubygems.org/gems/fakeit)
[![Docker Pulls](https://img.shields.io/docker/pulls/realfengjia/fakeit.svg)](https://hub.docker.com/r/realfengjia/fakeit)
[![GitHub](https://img.shields.io/github/license/JustinFeng/fakeit.svg)](https://opensource.org/licenses/MIT)

Create mock server from Openapi specification

## Features

* Randomly or statically generated response
* Request validation
* Load specification from local or remote
* Support specification in yaml or json format

**Note:** Only support json content type as of now

## Installation

Install it with:

    $ gem install fakeit

Or use the [docker image](https://hub.docker.com/r/realfengjia/fakeit)

## Usage

    $ fakeit --spec <Local file or remote url>

Command line options:

    $ fakeit --help
    usage:
        --spec         spec file uri (required)
        -p, --port     custom port
        -q, --quiet    mute request and response log
        --permissive   log validation error as warning instead of denying request
        --use-example  use example provided in spec if exists
        --static       generate static response

    other options:
        -v, --version
        -h, --help

**Notes:**
* See [here](docs/random.md) for Openapi properties supported in random response generation
* See [here](docs/static.md) for default value in static response generation
* Regarding `--use-example` mode, property without example specified will still be randomly or statically generated
* Random response generation can not handle recursive schema reference. If you do need it in your spec file, please provide `example` property for the recursive part of schema and specify `--use-example` option.

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/JustinFeng/fakeit.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
