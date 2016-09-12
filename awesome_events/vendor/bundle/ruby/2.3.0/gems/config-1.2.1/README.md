# Config

[![Build Status](https://api.travis-ci.org/railsconfig/config.svg?branch=master)](http://travis-ci.org/railsconfig/config)
[![Gem Version](https://badge.fury.io/rb/config.svg)](http://badge.fury.io/rb/config)
[![Dependency Status](https://gemnasium.com/railsconfig/config.svg)](https://gemnasium.com/railsconfig/config)
[![Code Climate](https://codeclimate.com/github/railsconfig/config/badges/gpa.svg)](https://codeclimate.com/github/railsconfig/config)
[![Issue Count](https://codeclimate.com/github/railsconfig/config/badges/issue_count.svg)](https://codeclimate.com/github/railsconfig/config)
[![Test Coverage](https://codeclimate.com/github/railsconfig/config/badges/coverage.svg)](https://codeclimate.com/github/railsconfig/config/coverage)

## Summary

Config helps you easily manage environment specific settings in an easy and usable manner.

## Features

* simple YAML config files
* config files support ERB
* config files support inheritance and multiple environments
* access config information via convenient object member notation
* support for multi-level settings (`Settings.group.subgroup.setting`)
* local developer settings ignored when committing the code

## Compatibility

* Ruby `2.x`
* Rails `>= 3.1`, `4` and `5`
* Padrino
* Sinatra

For older versions of Rails or Ruby use [AppConfig](http://github.com/fredwu/app_config).

## Installing

### Installing on Rails 3, 4 or 5

Add `gem 'config'` to your `Gemfile` and run `bundle install` to install it. Then run

    rails g config:install

which will generate customizable config file `config/initializers/config.rb` and set of default settings files:

    config/settings.yml
    config/settings/development.yml
    config/settings/production.yml
    config/settings/test.yml

You can now edit them to adjust to your needs.

If you want to use Settings before rails application initialization process you can load Config railtie manually:

```ruby
module Appname
  class Application < Rails::Application

    Bundler.require(*Rails.groups)
    Config::Integration::Rails::Railtie.preload

    # ...

    config.time_zone = Settings.time_zone

    # ...

  end
end
```

### Installing on Padrino

Add the gem to your `Gemfile` and run `bundle install` to install it. Then edit `app.rb` and register `Config`

```ruby
register Config
```

### Installing on Sinatra

Add the gem to your `Gemfile` and run `bundle install` to install it. Afterwards in need to register `Config` in your
app and give it a root so it can find the config files.

```ruby
set :root, File.dirname(__FILE__)
register Config
```

It's also possible to initialize `Config` manually within your configure block if you want to just give it some yml
paths to load from.

```ruby
Config.load_and_set_settings("/path/to/yaml1", "/path/to/yaml2", ...)
```

## Accessing the Settings object

After installing the gem, `Settings` object will become available globally and by default will be compiled from the
files listed below. Settings defined in files that are lower in the list override settings higher.

    config/settings.yml
    config/settings/#{environment}.yml
    config/environments/#{environment}.yml

    config/settings.local.yml
    config/settings/#{environment}.local.yml
    config/environments/#{environment}.local.yml

Entries can be accessed via object member notation:

```ruby
Settings.my_config_entry
```

Nested entries are supported:

```ruby
Settings.my_section.some_entry
```

Alternatively, you can also use the `[]` operator if you don't know which exact setting you need to access ahead of time.

```ruby
# All the following are equivalent to Settings.my_section.some_entry
Settings.my_section[:some_entry]
Settings.my_section['some_entry']
Settings[:my_section][:some_entry]
```

### Reloading settings

You can reload the Settings object at any time by running `Settings.reload!`.

### Reloading settings and config files

You can also reload the `Settings` object from different config files at runtime.

For example, in your tests if you want to test the production settings, you can:

```ruby
Rails.env = "production"
Settings.reload_from_files(
  Rails.root.join("config", "settings.yml").to_s,
  Rails.root.join("config", "settings", "#{Rails.env}.yml").to_s,
  Rails.root.join("config", "environments", "#{Rails.env}.yml").to_s
)
```

### Environment specific config files

You can have environment specific config files. Environment specific config entries take precedence over common config
entries.

Example development environment config file:

```ruby
#{Rails.root}/config/environments/development.yml
```

Example production environment config file:

```ruby
#{Rails.root}/config/environments/production.yml
```

### Developer specific config files

If you want to have local settings, specific to your machine or development environment,
you can use the following files, which are automatically `.gitignore` :

```ruby
Rails.root.join("config", "settings.local.yml").to_s,
Rails.root.join("config", "settings", "#{Rails.env}.local.yml").to_s,
Rails.root.join("config", "environments", "#{Rails.env}.local.yml").to_s
```

### Adding sources at runtime

You can add new YAML config files at runtime. Just use:

```ruby
Settings.add_source!("/path/to/source.yml")
Settings.reload!
```

This will use the given source.yml file and use its settings to overwrite any previous ones.

On the other hand, you can prepend a YML file to the list of configuration files:

```ruby
Settings.prepend_source!("/path/to/source.yml")
Settings.reload!
```

This will do the same as `add_source`, but the given YML file will be loaded first (instead of last) and its settings
will be overwritten by any other configuration file. This is especially useful if you want to define defaults.

One thing I like to do for my Rails projects is provide a local.yml config file that is .gitignored (so its independent
per developer). Then I create a new initializer in `config/initializers/add_local_config.rb` with the contents

```ruby
Settings.add_source!("#{Rails.root}/config/settings/local.yml")
Settings.reload!
```

> Note: this is an example usage, it is easier to just use the default local files `settings.local.yml,
settings/#{Rails.env}.local.yml and environments/#{Rails.env}.local.yml` for your developer specific settings.

## Embedded Ruby (ERB)

Embedded Ruby is allowed in the configuration files. Consider the two following config files.

* ```#{Rails.root}/config/settings.yml```

```yaml
size: 1
server: google.com
```

* ```#{Rails.root}/config/environments/development.yml```

```yaml
size: 2
computed: <%= 1 + 2 + 3 %>
section:
  size: 3
  servers: [ {name: yahoo.com}, {name: amazon.com} ]
```

Notice that the environment specific config entries overwrite the common entries.

```ruby
Settings.size   # => 2
Settings.server # => google.com
```

Notice the embedded Ruby.

```ruby
Settings.computed # => 6
```

Notice that object member notation is maintained even in nested entries.

```ruby
Settings.section.size # => 3
```

Notice array notation and object member notation is maintained.

```ruby
Settings.section.servers[0].name # => yahoo.com
Settings.section.servers[1].name # => amazon.com
```

## Configuration

There are multiple configuration options available, however you can customize `Config` only once, preferably during
application initialization phase:

```ruby
Config.setup do |config|
  config.const_name = 'Settings'
  ...
end
```

After installing `Config` in Rails, you will find automatically generated file that contains default configuration
located at `config/initializers/config.rb`.

### General

* `const_name` - name of the object holing you settings. Default: `'Settings'`

### Merge customization

* `knockout_prefix` - ability to remove elements of the array set in earlier loaded settings file. Default: `nil`

Check [Deep Merge](https://github.com/danielsdeleo/deep_merge) for more details.

### Environment variables

See section below for more details.

## Working with environment variables

To load environment variables from the `ENV` object, that will override any settings defined in files, set the `use_env`
to true in your `config/initializers/config.rb` file:

```ruby
Config.setup do |config|
  config.const_name = 'Settings'
  config.use_env = true
end
```

Now config would read values from the ENV object to the settings. For the example above it would look for keys starting
with `Settings`:

```ruby
ENV['Settings.section.size'] = 1
ENV['Settings.section.server'] = 'google.com'
```

It won't work with arrays, though.

### Working with Heroku

Heroku uses ENV object to store sensitive settings. You cannot upload such files to Heroku because it's ephemeral
filesystem gets recreated from the git sources on each instance refresh. To use config with Heroku just set the
`use_env` var to `true` as mentioned above.

To upload your local values to Heroku you could ran `bundle exec rake config:heroku`.

### Fine-tuning

You can customize how environment variables are processed:

* `env_prefix` - which variables to load into config
* `env_separator` - what string to use as level separator instead of dots - default value of `.` works well with
  Heroku, but you might want to change it for example for `__` to easy override settings from command line, where using
  dots in variable names might not be allowed (eg. Bash)
* `env_converter` - how to process variables names:
  * `nil` - no change
  * `:downcase` - convert to lower case
* `env_parse_values` - parse numeric values as integers instead of strings

For instance, given the following environment:

```bash
SETTINGS__SECTION__SERVER_SIZE=1
SETTINGS__SECTION__SERVER=google.com
```

And the following configuration:

```ruby
Config.setup do |config|
  config.use_env = true
  config.env_prefix = 'Settings'
  config.env_separator = '__'
  config.env_converter = :downcase
  config.env_parse_values = true
end
```

The following settings will be available:

```ruby
Settings.section.server_size # => 1
Settings.section.server # => 'google.com'
```

## Contributing

Bootstrap

```bash
appraisal install
```

Run the test suite:

```bash
appraisal rspec
```

If you modified any of the documentation files verify their format:

```bash
mdl --style .mdlstyle.rb *.md
```

## Authors

* [Piotr Kuczynski](http://github.com/pkuczynski)
* [Fred Wu](http://github.com/fredwu)
* [Jacques Crocker](http://github.com/railsjedi)
* Inherited from [AppConfig](http://github.com/cjbottaro/app_config) by [Christopher J. Bottaro](http://github.com/cjbottaro)

## License

Config is released under the [MIT License](http://www.opensource.org/licenses/MIT).
