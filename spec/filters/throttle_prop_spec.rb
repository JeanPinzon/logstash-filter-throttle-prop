# encoding: utf-8
require_relative '../spec_helper'
require "logstash/filters/throttle_prop"

describe LogStash::Filters::ThrottleProp do

  let(:config) do <<-CONFIG
    filter {
      throttle_prop {
        key => "%{property_key}"
        value => "%{property_value}"
        limit => 2
        add_tag => [ "throttled" ]
      }
    }
  CONFIG
  end

  describe "Throttling per property" do
    events = [{
      "property_key" => "some_key",
      "property_value" => "a"
    }, {
      "property_key" => "some_key",
      "property_value" => "b"
    }, {
      "property_key" => "some_key",
      "property_value" => "c"
    }]

    sample events do
      expect(subject[0].get("property_value")).to eq('a')
      expect(subject[1].get("property_value")).to eq('b')
      expect(subject[2].get("property_value")).to eq('c')
      expect(subject[2].get("tags")).to eq([ "throttled" ])
    end
  end

  describe "Don't throttling equal properties" do
    events = [{
      "property_key" => "some_key",
      "property_value" => "a"
    }, {
      "property_key" => "some_key",
      "property_value" => "a"
    }, {
      "property_key" => "some_key",
      "property_value" => "a"
    }]

    sample events do
      expect(subject[0].get("property_value")).to eq('a')
      expect(subject[1].get("property_value")).to eq('a')
      expect(subject[2].get("property_value")).to eq('a')
      expect(subject[2].get("tags")).to eq(nil)
    end
  end

  describe "Don't throttling equal properties and throttling differents" do
    events = [{
      "property_key" => "some_key",
      "property_value" => "a"
    }, {
      "property_key" => "some_key",
      "property_value" => "a"
    }, {
      "property_key" => "some_key",
      "property_value" => "b"
    }, {
      "property_key" => "some_key",
      "property_value" => "b"
    }, {
      "property_key" => "some_key",
      "property_value" => "c"
    }, {
      "property_key" => "some_key",
      "property_value" => "c"
    }, {
      "property_key" => "some_key",
      "property_value" => "a"
    }, {
      "property_key" => "some_key",
      "property_value" => "b"
    }, {
      "property_key" => "some_key",
      "property_value" => "c"
    }, {
      "property_key" => "some_key",
      "property_value" => "d"
    }, {
      "property_key" => "other_key",
      "property_value" => "d"
    }]

    sample events do
      expect(subject[0].get("property_value")).to eq('a')
      expect(subject[0].get("tags")).to eq(nil)

      expect(subject[1].get("property_value")).to eq('a')
      expect(subject[1].get("tags")).to eq(nil)

      expect(subject[2].get("property_value")).to eq('b')
      expect(subject[2].get("tags")).to eq(nil)

      expect(subject[3].get("property_value")).to eq('b')
      expect(subject[3].get("tags")).to eq(nil)

      expect(subject[4].get("property_value")).to eq('c')
      expect(subject[4].get("tags")).to eq([ "throttled" ])

      expect(subject[5].get("property_value")).to eq('c')
      expect(subject[5].get("tags")).to eq([ "throttled" ])

      expect(subject[6].get("property_value")).to eq('a')
      expect(subject[6].get("tags")).to eq(nil)

      expect(subject[7].get("property_value")).to eq('b')
      expect(subject[7].get("tags")).to eq(nil)

      expect(subject[8].get("property_value")).to eq('c')
      expect(subject[8].get("tags")).to eq([ "throttled" ])

      expect(subject[9].get("property_value")).to eq('d')
      expect(subject[9].get("tags")).to eq([ "throttled" ])

      expect(subject[10].get("property_value")).to eq('d')
      expect(subject[10].get("tags")).to eq(nil)
    end
  end

end
