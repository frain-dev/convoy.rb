# Convoy
This is the official Convoy Ruby SDK. This SDK contains methods for easily interacting with Convoy's API. Below are examples to get you started. For the full API reference, please take a look at our [docs](https://getconvoy.io/docs).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'convoy.rb'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install convoy.rb

## Usage

### Setup Client
To configure your client, provide your `base_uri`, `api_key` and `project_id`, see below:
```ruby
require 'convoy'

Convoy.ssl = true
Convoy.base_uri = "https://us.getconvoy.cloud/api"
Convoy.api_key = "CO.M0aBe..."
Convoy.project_id = "23b1..."
```

Your instance URL depends on where your project lives:

- Convoy Cloud (US): `https://us.getconvoy.cloud/api`
- Convoy Cloud (EU): `https://eu.getconvoy.cloud/api`
- Self-hosted: `https://your-instance/api`

### Create Endpoint
An endpoint represents a target URL to receive webhook events. You should create one endpoint per user/business or whatever scope works well for you. 

```ruby
endpoint = Convoy::Endpoint.new(
  data: {
    "name": "default-endpoint",
    "description": "Endpoint One",
    "url": "https://example.com/webhooks/convoy"
  }
)

endpoint_response = endpoint.save
```

### Subscribe For Events
After creating an endpoint, we need to susbcribe the endpoint to events. 

```ruby
subscription = Convoy::Subscription.new(
  data: {
    endpoint_id: endpoint_id,
    name: 'ruby subscription'
  }
)

subscription_response = subscription.save
```

### Send Event
To send an event, you'll need to pass the `uid` from the endpoint we created earlier.

```ruby
event = Convoy::Event.new(
  data: {
    endpoint_id: endpoint_id,
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

To fan an event out to all endpoints with the same `owner_id`, or broadcast to every endpoint in the project:

```ruby
fanout_response = Convoy::Event.new(
  data: {
    owner_id: "owner-1",
    event_type: "wallet.created",
    data: { status: "completed" }
  }
).fanout

broadcast_response = Convoy::Event.new(
  data: {
    event_type: "wallet.created",
    data: { status: "completed" }
  }
).broadcast
```

### Verify Webhook Signatures
Verify with the raw request body, before parsing it. `verify` returns `true` or `false` for simple signatures, and raises `Convoy::SignatureVerificationError` for invalid advanced signatures.

```ruby
webhook = Convoy::Webhook.new("endpoint-secret")

begin
  valid = webhook.verify(request.raw_post, request.headers["X-Convoy-Signature"])
rescue Convoy::SignatureVerificationError
  valid = false
end

head :bad_request and return unless valid
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
