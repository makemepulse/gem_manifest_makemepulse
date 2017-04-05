# ManifestMakemepulse

This GEM generate your manifest JS file to be used with WK workflow in a Rails application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'manifest_makemepulse'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install manifest_makemepulse

## Usage

By default, `.js`, `.erb`, `.css`, `.map`, `.erb` are excluded.
The GEM will generate a `assets-manifest.js.erb` file in your `app/assets/javascripts/` folder

You can add some configuration in your Rails application.


```RUBY
  config.manifest.exclude << ".ext"
  config.manifest.exclude << "folderName/"
  config.manifest.exclude << "filename.ext"
  config.manifest.output_location = "your location"
  config.manifest.output_file = "your filename"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/manifest_makemepulse. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

