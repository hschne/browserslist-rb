# browserslist-rb

Bringing [browserlist](https://github.com/browserslist/browserslist) to Ruby. Bring your existing browserlists config and use it in [Rails allowed browsers](https://github.com/rails/rails/pull/50505).

```
allow_browser versions: Browserlist.browsers
```

## Installation

Add `browserlists` to your `Gemfile`.

```bash
bundle add browserslist
```

## Usage

### Generating a Browserlist

`browserlist-rb` relies on a Browserslist file to be generated upfront, or at build time. How you do that, is up to you. This gem ships with a generator, that requires `npm/npx` to be installed.

```bash
bundle exec browserslist
# Generated browserslist file: .browserslist
```

This command will respect your [browserslist](https://github.com/browserslist/browserslist) configuration. For example, if you set up [browserslist-config-baseline](https://github.com/web-platform-dx/browserslist-config-baseline) the contents of `.browserslist` will change accordingly.

### Using the Browserlist

Once you have generated your Browserslist, `browserslist-rb` will provide a hash of minimum-required browser versions for you. 

```ruby
Browserslist.browsers
# => { chrome: 110.0, firefox: 110.0, edge: 110.0, safari: 16.0, opera: false, ie: false} 
```

You may use this in conjunction with [Rails 8.0 allowed browsers syntax](https://github.com/rails/rails/pull/50505)].

```
allow_browser versions: Browserlist.browsers
```
## Configuration


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/browserslist. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/browserslist/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Browserslist project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/browserslist/blob/main/CODE_OF_CONDUCT.md).
