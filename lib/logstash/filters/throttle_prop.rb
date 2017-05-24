# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

# The throttle-prop-filter is to throttle events per a dynamic property.
# The filter is configured with a key, a value and a limit.
# The key is used to group the values.
# If the values with a different content are be inserted more
# than limit, it will be filtered
#
#
# For example, if you wanted to throttle events per a property "type",
# and you didn't want to have more than two differents types,
# you would use the configuration:
#
# [source, ruby]
#     key => "%{property_key}"
#     value => "%{type}"
#     limit => 2
#
# Which would result in:
# ==========================
#     event 1  { property_key => 'some_key', type => 'a' } - not throttled
#     event 2  { property_key => 'some_key', type => 'a' } - not throttled
#     event 3  { property_key => 'some_key', type => 'b' } - not throttled
#     event 4  { property_key => 'some_key', type => 'b' } - not throttled
#     event 5  { property_key => 'some_key', type => 'c' } - throttled (successful filter)
#     event 6  { property_key => 'some_key', type => 'c' } - throttled (successful filter)
#     event 7  { property_key => 'some_key', type => 'a' } - not throttled
#     event 8  { property_key => 'some_key', type => 'b' } - not throttled
#     event 9  { property_key => 'some_key', type => 'c' } - throttled (successful filter)
#     event 10 { property_key => 'some_key', type => 'd' } - throttled (successful filter)
#     event 11  { property_key => 'other_key', type => 'd' } - not throttled

class LogStash::Filters::ThrottleProp < LogStash::Filters::Base

  config_name "throttle_prop"

  config :key, :validate => :string, :required => true

  config :value, :validate => :string, :required => true

  config :limit, :validate => :number, :required => true

  public
  def register
    @keys = Hash.new
  end # def register

  public
  def filter(event)
    event_key = event.sprintf(@key)
    event_value = event.sprintf(@value)
    event_limit = event.sprintf(@limit).to_i

    if @keys.has_key? event_key
      unless @keys[event_key].include? event_value
        if @keys[event_key].length + 1 > event_limit
          filter_matched(event)
        else
          @keys[event_key].push(event_value)
        end
      end
    else
      @keys[event_key] = [event_value]
    end

  end # def filter
end # class LogStash::Filters::ThrottleProp
