require './lib/emf.rb'

describe "Version" do
    it "should be version 0.0.1" do
        Emf::VERSION.should eq('0.0.1')
    end
end


