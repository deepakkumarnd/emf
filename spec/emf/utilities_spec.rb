require 'spec_helper'

describe Emf::Utilities do
    it "should write the string to the output device without any exceptions" do
        klass = Class.new { extend Emf::Utilities }
        klass.write("Testting write method SUCCESS")
    end
end
