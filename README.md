# Logstash Filter Throttle Prop

This is a plugin for [Logstash](https://github.com/elastic/logstash).

It is fully free and fully open source. The license is Apache 2.0, meaning you are pretty much free to use it however you want in whatever way.

The logstash-filter-throttle-prop is to throttle events per a dynamic property. The filter is configured with a key, a value and a limit. The key is used to group the values. If the values with a different content are inserted more than limit, it will be filtered.


## How to install

```sh
bin/logstash-plugin install logstash-filter-throttle-prop
```

## Hou to use

For example, if you wanted to throttle events per a property "type",
and you didn't want to have more than two differents types,
you would use the configuration:

```ruby
filter {
  throttle_prop {
    key => "fixed_key"
    value => "%{type}"
    limit => 2
    add_tag => [ "throttled" ]
  }
}
```

##### Which would result in:
   - event 1  { type => 'a' } - not throttled
   - event 2  { type => 'a' } - not throttled
   - event 3  { type => 'b' } - not throttled
   - event 4  { type => 'b' } - not throttled
   - event 5  { type => 'c' } - throttled (successful filter)
   - event 6  { type => 'c' } - throttled (successful filter)
   - event 7  { type => 'a' } - not throttled
   - event 8  { type => 'b' } - not throttled
   - event 9  { type => 'c' } - throttled (successful filter)
   - event 10 { type => 'd' } - throttled (successful filter)

## Developing

### 1. Plugin Developement and Testing

#### Code
- To get started, you'll need JRuby with the Bundler gem installed.

- Install dependencies
```sh
bundle install
```

#### Test

- Update your dependencies

```sh
bundle install
```

- Run tests

```sh
bundle exec rspec
```
