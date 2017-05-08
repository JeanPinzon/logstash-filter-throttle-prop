# encoding: utf-8
require_relative '../spec_helper'
require "logstash/filters/throttle_prop"

describe LogStash::Filters::ThrottleProp do
  describe "Set to Hello World" do
    let(:config) do <<-CONFIG
      filter {
        throttle_prop {
          message => "Hello World"
        }
      }
    CONFIG
    end

    sample("message" => "some text") do
      expect(subject.get("message")).to eq('Hello World')
    end
  end
end
