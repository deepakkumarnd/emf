#!/usr/bin/env ruby
$LOAD_PATH<< './lib'

require 'optparse'

require 'emf/version'
require 'emf/server'
require 'pp'

class ArgumentParser
    def self.parse(args)
        commands = %w{ new server generate console }
        options  = {}
        options[:quiet]     = false
        options[:root_path] = Dir.pwd
        options[:env]       = :development
        OptionParser.new do |opts|
            opts.banner = "Usage:\n emf new APP_PATH [options]"
            opts.on('-e', '--environment ENV', [:test, :development, :production ], 'Running environment test, development or production') { |e| options[:env] = e }
            opts.on('-q', '--quiet', 'Quiet mode') { options[:quiet] = true }
            opts.on_tail('-v', '--version', 'Prints version information') { puts "Emf #{Emf::VERSION}" }
            opts.on_tail('-h', '--help', "Prints help information") { puts opts }
        end.parse!(args)
        options
    end
end

options = ArgumentParser.parse(ARGV)
pp options
