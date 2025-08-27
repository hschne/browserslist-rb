# Browserslist Ruby

Bring [browserslist](https://github.com/browserslist/browserslist) to Ruby. Use your existing browserslist config and convert it to a Ruby hash for use with [Rails allowed browsers](https://github.com/rails/rails/pull/50505).

```ruby
allow_browser versions: Browserslist.browsers
```

## Installation

Add `browserslist` to your `Gemfile`:

```bash
bundle add browserslist
```

## Usage

### Generating a Browserslist

`browserslist-rb` reads from a `.browserslist.json` file that must be generated upfront or at build time. This gem ships with a generator that requires `npm/npx` to be installed. If you generate the file upfront you must make sure it's available at runtime.

```bash
# Generate default .browserslist.json file
bundle exec browserslist generate
```

#### Build-Time Generation

For Rails applications using modern bundlers, you can generate the browserslist file at build time, depending on your tooling.

<details>
<summary>Vite Ruby</summary>

Add to `vite.config.ts` using a plugin:

```typescript
import { defineConfig } from 'vite'
import { execSync } from 'child_process'

export default defineConfig({
  plugins: [
    {
      name: 'browserslist-generator',
      configResolved() {
        execSync('npx browserslist --json > .browserslist.json')
      }
    }
  ]
})
```
</details>

<details>
<summary>esbuild</summary>

Use a build plugin in your esbuild configuration:

```javascript
require('esbuild').build({
  plugins: [{
    name: 'browserslist-generator',
    setup(build) {
      build.onStart(() => {
        const browserslist = require('browserslist')
        const fs = require('fs')
        fs.writeFileSync('./.browserslist.json', JSON.stringify(browserslist()))
      })
    }
  }]
})
```
</details>

<details>
<summary>Asset Precompilation</summary>

You may use the built-in rake task to hook into your asset precompilation process. First require the Rake tasks, then enhance your asset precompilation. Add this to your `lib/tasks/assets.rake`:

```ruby
require 'browserslist/rake'

Rake::Task['assets:precompile'].enhance(['browserslist:update'])
```
</details>

### Using the API

Once you have generated your browserslist file, the gem provides a hash of minimum required browser versions:

```ruby
Browserslist.browsers
# => {chrome: 119.0, firefox: 128.0, edge: 138.0, safari: 18.4, opera: 80.0, ie: false}
```
For example with Rails 8.0+ allowed browsers:

```ruby
allow_browser versions: Browserslist.browsers
```

You may preview the resulting hash using 

```bash
bundle exec browserslist browsers
# => {chrome: 119.0, firefox: 128.0, edge: 138.0, safari: 18.4, opera: 80.0, ie: false}
```


## Configuration

Configure the gem like so:

```ruby
Browserslist.configure do |config|
  # Set custom file path 
  config.file_path = ".browserslist.json"
  
  # Enable/disable strict mode 
  # When strict mode is enabled, missing browsers hash value will be set to false, which in conjunction with `allow_browser` means they will be forbidden from accessing your application.
  config.strict = true
end
```

## Browser Support

The gem supports these browsers:
- **Chrome** (`chrome`, `and_chr`)
- **Firefox** (`firefox`, `and_ff`) 
- **Safari** (`safari`, `ios_saf`)
- **Edge** (`edge`)
- **Opera** (`opera`, `op_mob`)
- **Internet Explorer** (`ie`)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hschne/browserslist-rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
