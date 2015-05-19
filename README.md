[![Circle CI](https://circleci.com/gh/transitland/transitland-ruby-client.svg?style=svg)](https://circleci.com/gh/transitland/transitland-ruby-client)
[![Gem Version](https://badge.fury.io/rb/transitland-client.svg)](http://badge.fury.io/rb/transitland-client)

# transitland-(ruby)-client

This Ruby library enables you to read from the [Transitland Feed Registry](https://github.com/transitland/transitland-feed-registry). In the future, it will also provide access to the [Transitland Datastore](https://github.com/transitland/transitland-datastore), and allow you to write to both.

## Installation

These instructions assume you already have a Ruby 2.0+ interpreter available for local use.

Add this line to your application's Gemfile:

```ruby
gem 'transitland-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install transitland-client

## Configuration

The following settings can be changed with environment variables:

Environment variable name        | default value
-------------------------------- | -------------
`TRANSITLAND_FEED_REGISTRY_URL`  | `git@github.com:transitland/transitland-feed-registry.git`
`TRANSITLAND_FEED_REGISTRY_PATH` | `./tmp/transitland-feed-registry`

## Usage

This library is intended for use within other software and services. It also includes its own console, which lets developers try functionality locally.

To start the console:

    bundle exec rake console

To load a local copy of the [Transitland Feed Registry](https://github.com/transitland/transitland-feed-registry):

    [1] pry(main)> TransitlandClient::FeedRegistry.repo

To list all registries in the Feed Registry:

    [2] pry(main)> TransitlandClient::Entities::Feed.all

That returns a standard Ruby array, so you can also perform operators like counting the number of feeds in the registry:

    [3] pry(main)> TransitlandClient::Entities::Feed.all.count
    => 20

To find a single feed by its [Onestop ID](https://github.com/transitland/onestop-id):

    [4] pry(main)> TransitlandClient::Entities::Feed.find_by(onestop_id: 'f-9q9-actransit')

To find all feeds that include an operator by its [Onestop ID](https://github.com/transitland/onestop-id):

    [5] pry(main)> TransitlandClient::Entities::Feed.find_by(onestop_id: 'o-dhw-miamidadetransit')

To find all feeds by a tag key and value:

    [6] pry(main)> TransitlandClient::Entities::Feed.find_by(tag_key: 'license', tag_value: 'Creative Commons Attribution 3.0 Unported License')

To find all feeds that include an operator identifier:

    [7] pry(main)> TransitlandClient::Entities::Feed.find_by(operator_identifier: 'usntd://4034')

To get the URL for a feed:

    [8] pry(main)> TransitlandClient::Entities::Feed.find_by(onestop_id: 'f-9q9-bayarearapidtransit').url

To update the local copy of the Feed Registry (pulling any recent commits):

    [9] pry(main)> TransitlandClient::FeedRegistry.repo(force_update: true)
