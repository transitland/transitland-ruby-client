# transitland-(ruby)-client
[![Circle CI](https://circleci.com/gh/transitland/transitland-ruby-client.svg?style=svg)](https://circleci.com/gh/transitland/transitland-ruby-client)
[![Gem Version](https://badge.fury.io/rb/transitland-client.svg)](http://badge.fury.io/rb/transitland-client)

*MIGRATION WARNING*. As of March 2016, this client library is being updated to work with Transitland's [Datastore API](https://github.com/transitland/transitland-datastore/blob/master/README.md#api-endpoints). It will be broken in the meantime. Thank you for your patience!

## Installation

These instructions assume you already have a Ruby 2.0+ interpreter available for local use.

Add this line to your application's Gemfile:

```ruby
gem 'transitland_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install transitland_client

## Usage

This library is intended for use within other software and services. It also includes its own console, which lets developers try functionality locally.

To start the console:

    bundle exec rake console

To find a single feed by its [Onestop ID](https://github.com/transitland/onestop-id):

    [1] pry(main)> TransitlandClient::Feed.find_by(onestop_id: 'f-9q9-caltrain')

To get the URL for a feed:

    [2] pry(main)> TransitlandClient::Feed.find_by(onestop_id: 'f-9q9-caltrain').get(:url)
