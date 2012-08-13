require 'spec_helper'

describe "Version" do
    it "should be version 0.0.1" do
        Emf::VERSION.should eq('0.0.1')
    end
end


