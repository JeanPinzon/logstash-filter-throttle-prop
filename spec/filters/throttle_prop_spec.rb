# encoding: utf-8
require_relative '../spec_helper'
require "logstash/filters/throttle_prop"

describe LogStash::Filters::ThrottleProp do

  let(:config) do <<-CONFIG
    filter {
      throttle_prop {
        key => "test"
        value => "%{property}"
        limit => 2
        add_tag => [ "throttled" ]
      }
    }
  CONFIG
  end

  describe "Throttling per property" do
    events = [{
      "property" => "a"
    }, {
      "property" => "b"
    }, {
      "property" => "c"
    }]

    sample events do
      expect(subject[0].get("property")).to eq('a')
      expect(subject[1].get("property")).to eq('b')
      expect(subject[2].get("property")).to eq('c')
      expect(subject[2].get("tags")).to eq([ "throttled" ])
    end
  end

  describe "Don't throttling equal properties" do
    events = [{
      "property" => "a"
    }, {
      "property" => "a"
    }, {
      "property" => "a"
    }]

    sample events do
      expect(subject[0].get("property")).to eq('a')
      expect(subject[1].get("property")).to eq('a')
      expect(subject[2].get("property")).to eq('a')
      expect(subject[2].get("tags")).to eq(nil)
    end
  end

  describe "Don't throttling equal properties and throttling differents" do
    events = [{
      "property" => "a"
    }, {
      "property" => "a"
    }, {
      "property" => "b"
    }, {
      "property" => "b"
    }, {
      "property" => "c"
    }, {
      "property" => "c"
    }, {
      "property" => "a"
    }, {
      "property" => "b"
    }, {
      "property" => "c"
    }, {
      "property" => "d"
    }]

    sample events do
      expect(subject[0].get("property")).to eq('a')
      expect(subject[1].get("property")).to eq('a')
      expect(subject[2].get("property")).to eq('b')
      expect(subject[3].get("property")).to eq('b')
      expect(subject[4].get("property")).to eq('c')
      expect(subject[5].get("property")).to eq('c')
      expect(subject[4].get("tags")).to eq([ "throttled" ])
      expect(subject[5].get("tags")).to eq([ "throttled" ])
      expect(subject[6].get("property")).to eq('a')
      expect(subject[7].get("property")).to eq('b')
      expect(subject[8].get("property")).to eq('c')
      expect(subject[8].get("tags")).to eq([ "throttled" ])
      expect(subject[9].get("property")).to eq('d')
      expect(subject[9].get("tags")).to eq([ "throttled" ])
    end
  end

end
