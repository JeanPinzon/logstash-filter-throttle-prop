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
#     key => "fixed_key"
#     value => "%{type}"
#     limit => 2
#
# Which would result in:
# ==========================
#     event 1  { type => 'a' } - not throttled
#     event 2  { type => 'a' } - not throttled
#     event 3  { type => 'b' } - not throttled
#     event 4  { type => 'b' } - not throttled
#     event 5  { type => 'c' } - throttled (successful filter)
#     event 6  { type => 'c' } - throttled (successful filter)
#     event 7  { type => 'a' } - not throttled
#     event 8  { type => 'b' } - not throttled
#     event 9  { type => 'c' } - throttled (successful filter)
#     event 10 { type => 'd' } - throttled (successful filter)

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
    key = event.sprintf(@key)
    value = event.sprintf(@value)
    limit = event.sprintf(@limit).to_i

    if @keys.has_key? @key
      unless @keys[@key].include? value
        if @keys[@key].length + 1 > limit
          filter_matched(event)
        else
          @keys[@key].push(value)
        end
      end
    else
      @keys[@key] = [value]
    end

  end # def filter
end # class LogStash::Filters::ThrottleProp
