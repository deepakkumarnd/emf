require './lib/emf.rb'

describe ArgumentParser do
    it "Should set default arguments if no options are specified, quiet = false" do
      options = ArgumentParser.parse []
      options[:quiet].should be_false
    end

    it "Should set default environment if no environment is specified" do
      options = ArgumentParser.parse []
      options[:env].should eq(:development)
    end

    it "Should  set the default directory to current directory" do
      options = ArgumentParser.parse []
      options[:root_path].should eq(Dir.pwd)
    end

    it "Should set the quiet mode to true if -q option is provided" do
      options = ArgumentParser.parse %w{-q}
      options[:quiet].should be_true
    end
end
