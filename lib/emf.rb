#!/usr/bin/env ruby
$LOAD_PATH<< './lib'

require 'optparse'
require 'fileutils'
require 'pry'

require 'emf/version'
require 'emf/exceptions'
require 'emf/utilities'

autoload :Server, 'emf/server'

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
        options[:root_path] = Dir.pwd
        options[:env]       = :development

        OptionParser.new do |opts|
            opts.banner = "Usage:\n emf new APP_PATH [options]"
            opts.on('-e', '--environment ENV', [:test, :development, :production ], 'Running environment test, development or production') { |e| options[:env] = e }
            opts.on('-q', '--quiet', 'Quiet mode') { options[:quiet] = true }
            opts.on_tail('-v', '--version', 'Prints version information') { puts "Emf #{Emf::VERSION}"; exit }
            opts.on_tail('-h', '--help', "Prints help information") { puts(opts); exit }
        end.parse!(args)

        sub_command = args.shift
        print_command_usage_info and exit unless SUB_COMMANDS.include?(sub_command)
        options[:sub_command]         = sub_command
        options[:sub_command_options] = args unless args.empty?
        options
    end

    def self.print_command_usage_info
        puts USAGE
    end
end

module Emf
    class Emf
        include Exceptions
        include Utilities

        def initialize args
            @options = ArgumentParser.parse(args)
            if @options.has_key?(:sub_command)
                case @options[:sub_command]
                  when 'new' then new
                  when 'server' then server
                  when 'console' then console
                  when 'destroy' then puts "Yet to implement"
                  when 'generate' then puts "Yet to implement"
                end
            end
        end

        def new
          raise OptionNotFoundError unless @options.has_key?(:sub_command_options)
          @options[:root_path] = File.expand_path(@options[:sub_command_options].shift)
          root_path            = @options[:root_path]
          raise DuplicateDirectoryError if Dir.exists?(root_path)
          raise InvalidPathError unless Dir.exists?(File.dirname(root_path))
          @options[:app_name]  = File.basename(root_path)

          # create the application directory structure
          skel_path = "#{File.dirname(File.expand_path(__FILE__))}/skel"
          FileUtils.cp_r(skel_path, root_path)
        rescue Exception => e
          write e.message
        end

        def server
            Server.new(@options)
        end

        def console
          exec('irb -remf')
        end
    end
end

