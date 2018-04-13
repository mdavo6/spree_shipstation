Spree/ShipStation Integration
==============================
[![TravisCI](https://travis-ci.org/MatthewKennedy/spree_shipstation.svg?branch=master)](https://travis-ci.org/MatthewKennedy/spree_shipstation) [![Code Climate](https://codeclimate.com/github/MatthewKennedy/spree_shipstation/badges/gpa.svg)](https://codeclimate.com/github/MatthewKennedy/spree_shipstation)

This gem integrates [ShipStation](https://www.shipstation.com) with [Spree](https://spreecommerce.com). It enables ShipStation to pull shipments from the Spree store and update tracking numbers. This integration is ported from the Solidus extention https://github.com/boomerdigital/solidus_shipstation and made compatible with Spree 3 and Rails 5.1+.

See below for more documentation on the ShipStation API or how shipments and orders work in Spree:

- [ShipStation Custom Store Overview](https://help.shipstation.com/hc/en-us/articles/205928478#1c)
- [ShipStation Custom Store Dev Guide](https://app.shipstation.com/content/integration/ShipStationCustomStoreDevGuide.pdf)

## Integration Overview

`spree_shipstation` exposes two API endpoints for ShipStation's Custom Store API to **pull** data from:

**GET /shipstation**
Will return an XML formatted, paginated list of order/shipment details for the requested time frame and conforms to [ShipStation's specifed XML schema](https://help.shipstation.com/hc/en-us/articles/205928478-ShipStation-Custom-Store-Development-Guide#4b). However, in practice, ShipStation will use a narrow time frame (1 day) to request order updates. You can configure how often data is pulled in the ShipStation UI.

```ruby
# GET Example
localhost:3000/shipstation?action=export&end_date=12%2F31%2F2016+00%3A00&format=xml&start_date=01%2F01%2F2016+00%3A00
```

**POST /shipstation**
This endpoint allows ShipStation to send updates on a shipment. Below are the parameters you can expect to receive from ShipStation:

```ruby
{
 "SS-UserName"=>"this-is-my-username",
 "SS-Password"=>"this-is-my-password",
 "action"=>"shipnotify",
 "order_number"=>"R1334232",
 "carrier"=>"UPS",
 "service"=>"USPS Priority",
 "tracking_number"=>"12312312001303",
 "format"=>"xml"
}
```

```ruby
# POST Example
localhost:3000/shipstation?action=shipnotify&order_number=ABC123&carrier=USPS&service=USPS+Priority&tracking_number=123456&format=xml
```

## Setup

Add `spree_shipstation` to your Gemfile:

```ruby
gem 'spree_shipstation', github: 'matthewkennedy/spree_shipstation'
```

Then, bundle install

    $ bundle install

Configure your ShipStation integration:

```ruby
# config/initializers/spree.rb
Spree.config do |config|

  # ShipStation Configuration
  # choose between Grams, Ounces or Pounds
  config.shipstation_weight_units = "Grams"

  # ShipStation expects the endpoint to be protected by HTTP Basic Auth. Set the
  # username and password you desire for ShipStation to use
 if Rails.env.production?
  # You should set these in your Heroku Config Variables
  config.shipstation_username = ENV['SHIPSTATION_USERNAME']
  config.shipstation_password = ENV['SHIPSTATION_PASSWORD']
 else
  config.shipstation_username = "MyUserName"
  config.shipstation_password = "MySuperSecurePassword123"
 end
  
  # Turn on/off SSL requirepments for testing and development purposes
  config.shipstation_ssl_encrypted = !Rails.env.development?

  # Captures payment when ShipStation notifies a shipping label creation, defaults to false
  config.shipstation_capture_at_notification = false
 
end
```

### Configuring ShipStation

To configure or create a ShipStation store, go to **Settings** and select **Stores**. Then click **Add Store**, scroll down and choose the **Custom Store** option.

- For **Username**, enter the username defined in your config
- For **Password**, enter the password defined in your config
- For **URL to custom page**, enter your URL: `https://mydomain.com/shipstation.xml`

There are five primary shipment states for an order/shipment in ShipStation. Order is ShipStation's terminology, Spree uses Shipments. These states do not necessarily align with Spree, but in the store configuration you can create a mapping for your specific needs.

ShipStation mapping depends on your store's configuration. Please see the notes above regarding `config/initializers/spree.rb` and adjust your states accordingly.

ShipStation Status Title | ShipStation Status | Spree::Shipment#state
-------------------------|--------------------|-----------------
Awaiting Payment         | unpaid             | pending (won't appear in API response)
Awaiting Shipment        | paid               | ready
Shipped                  | shipped            | shipped
Cancelled                | cancelled          | cancelled
On-Hold                  | on-hold            | pending (won't appear in API response)

### Payment Capture

By default the shipments exported are only the ones that have the state of `ready`, for Spree that means
that the shipment has backordered inventory units and the order is paid for. By setting
`require_payment_to_ship` to `false` and `shipstation_capture_at_notification` to `true`
this extension will export shipments that are in the state of `pending` and will
try to capture payments when a shipnotify notification is received.


## Testing

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test_app

To run tests:

    $ bundle exec rspec spec

To run tests with guard:

    $ bundle exec guard


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -m 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Future Work

- Write better tests.

