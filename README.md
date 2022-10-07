# Convoy
This is the official Convoy Ruby SDK. This SDK contains methods for easily interacting with Convoy's API. Below are examples to get you started. For additional examples, please see our official documentation at (https://convoy.readme.io/reference)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'convoy.rb'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install convoy

## Usage

### Setup Client

```ruby
require 'convoy'

Convoy.ssl = true
Convoy.api_key = "CO.M0aBe..."
Convoy.path_version = "v1"
Convoy.base_uri = "https://dashboard.getconvoy.io/api"

```

### Creating an application
An application represents a user's application trying to receive webhooks. Once you create an application, you'll receive a `uid` as part of the response that you should save and supply in subsequent API calls to perform other requests such as creating an event.

```ruby
app = Convoy::Application.new(
  params: {
    groupID: "c3637195-53cd-4eba-b9df-e7ba9479fbb2"
  },
  data: {
    name: "Integration One"
  }
)

app_response = app.save
```

### Add an Endpoint to Application
After creating an application, you'll need to add an endpoint to the application you just created. An endpoint represents a target URL to receive events.

```ruby
endpoint = Convoy::Endpoint.new(
  app_id,
  data: {
    "description": "Endpoint One",
    "http_timeout": "1m",
    "url": "https://webhook.site/73932854-a20e-4d04-a151-d5952e873abd"
  }
)

endpoint_response = endpoint.save
```

### Subscribe For Events
After creating an endpoint, we need to susbcribe the endpoint to events. 

```ruby
subscription = Convoy::Subscription.new(
  data: {
    app_id: app_id,
    endpoint_id: endpoint_id
    name: 'ruby subscription',
    filter_config: {
      event_types: [ "*" ]
    }
  }
)

subscription_response = subscription.save
```

### Publish an Event
Now let's publish an event.

```ruby
event = Convoy::Event.new(
  data: {
    app_id: app_id,
    event_type: "wallet.created",
    data: {
      status: "completed",
      event_type: "wallet.created",
      description: "transaction successful"
    }
  }
)

event_response = event.save
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/convoy. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/convoy/blob/master/CODE_OF_CONDUCT.md).


## Credits

- [Frain](https://github.com/frain-dev)

## License

The MIT License (MIT). Please see [License File](LICENSE) for more information.
