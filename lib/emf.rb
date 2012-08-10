#!/usr/bin/env ruby
$LOAD_PATH<< './lib'

require 'optparse'

require 'emf/version'
require 'emf/server'
require 'emf/exceptions'
require 'emf/utilities'
require 'pp'

class ArgumentParser
USAGE = <<DOC
            Error: Command not recognized
            Usage: emf COMMAND [ARGS]

            The most common emf commands are:
            generate    Generate new code (short-cut alias: "g")
            console     Start the Emf console (short-cut alias: "c")
            server      Start the Emf server (short-cut alias: "s")
            new         Create a new Emf application. "emf new my_app" creates a
                        new application called MyApp in "./my_app"
            destroy     Undo code generated with "generate"
DOC

    SUB_COMMANDS = %w{ new server generate console destroy }

    def self.parse(args)
        options  = {}
        options[:quiet]     = false
        #options[:root_path] = Dir.pwd
        options[:env]       = :development

        OptionParser.new do |opts|
            opts.banner = "Usage:\n emf new APP_PATH [options]"
            opts.on('-e', '--environment ENV', [:test, :development, :production ], 'Running environment test, development or production') { |e| options[:env] = e }
            opts.on('-q', '--quiet', 'Quiet mode') { options[:quiet] = true }
            opts.on_tail('-v', '--version', 'Prints version information') { puts "Emf #{Emf::VERSION}" and exit }
            opts.on_tail('-h', '--help', "Prints help information") { puts(opts) and exit }
        end.parse!(args)

        sub_command = args.shift
        if SUB_COMMANDS.include?(sub_command)
            options[:sub_command]         = sub_command
            options[:sub_commnad_options] = args unless args.empty?
        end
        options
    end

    private

    def print_command_usage_info
        write USAGE
    end
end

module Emf
    class Emf
        include Exceptions
        include Utilities

        def initialize
            @options = ArgumentParser.parse(ARGV)
            if @options.has_key?(:sub_command)
                case @options[:sub_command]
                  when 'new' then new
                  when 'server' then puts "Yet to implement"
                  when 'console' then console
                  when 'destroy' then puts "Yet to implement"
                  when 'generate' then puts "Yet to implement"
                  else
                      write ArgumentParser::USAGE
                end
            end
        end

        def new
          raise OptionNotFoundError unless @options.has_key?(:sub_command_options)
          @options[:root_path] = File.expand_path(@options[:sub_command_option].shift)
          root_path            = @options[:root_path]
          raise DuplicateDirectoryError if Dir.exists?(root_path)
          raise InvalidPathError unless Dir.exists?(File.dirname(root_path))
          @options[:app_name]  = File.basename(root_path)

          # create the application directory structure
          Dir.mkdir(@options[:root_path])
          Dir.mkdir("#{root_path}/app")
          Dir.mkdir("#{root_path}/app/controllers")
          Dir.mkdir("#{root_path}/app/models")
          Dir.mkdir("#{root_path}/app/views")
          Dir.mkdir("#{root_path}/app/helpers")
          Dir.mkdir("#{root_path}/app/assets")
          Dir.mkdir("#{root_path}/app/assets/javascripts")
          Dir.mkdir("#{root_path}/app/assets/stylesheets")
          Dir.mkdir("#{root_path}/app/assets/images")
          Dir.mkdir("#{root_path}/config")
          Dir.mkdir("#{root_path}/config/initializers")
          Dir.mkdir("#{root_path}/db")
          Dir.mkdir("#{root_path}/lib")
          Dir.mkdir("#{root_path}/log")
          Dir.mkdir("#{root_path}/doc")
          Dir.mkdir("#{root_path}/spec")
          Dir.mkdir("#{root_path}/script")
          Dir.mkdir("#{root_path}/public")
          Dir.mkdir("#{root_path}/test")

        rescue Exception => e
          write e.message
        end

        def console
          exec('irb -remf')
        end
    end
end

Emf::Emf.new
