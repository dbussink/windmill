gem 'jsonrpc'

require 'jsonrpc'

require File.expand_path(File.join(File.dirname(__FILE__), 'windmill', 'version'))

module Windmill

  class Client

    def initialize(url)
      @jsonrpc = JsonRPC::Client.new(url)
      # Retrieve all available API methods
      
      result = execute_command(:method => "commands.getControllerMethods")
      if result["status"]
        result["result"].each do |full_method|
          method = full_method
          if loc = method.index('.')
            method = method[(loc + 1) .. method.size]
          end
          if method =~ /command/
            self.class.class_eval <<-RUBY, __FILE__, __LINE__ + 1
              def #{method}(*args)
                if args.empty?
                  args = {}
                elsif args.size == 1
                  args = args.first
                end
                execute_command(:method => "#{full_method}", :params => args)
              end
            RUBY
          else
            self.class.class_eval <<-RUBY, __FILE__, __LINE__ + 1
              def #{method}(*args)
                if args.empty?
                  args = {}
                elsif args.size == 1
                  args = args.first
                end
                execute_test(:method => "#{full_method}", :params => args)
              end
            RUBY
          end
        end
      end
    end

    def execute_command(action_object = {})
      action_object[:params] ||= {}
      result = @jsonrpc.request("execute_command", :action_object => action_object)
      result["result"]
    end

    def execute_test(action_object = {})
      action_object[:params] ||= {}
      result = @jsonrpc.request("execute_test", :action_object => action_object)
      result["result"]
    end

    def waits
      self
    end

    def asserts
      self
    end

    def start_suite(suite_name)
      result = @jsonrpc.request("start_suite", :suite_name => suite_name)
      result["result"]
    end

    def stop_suite
      result = @jsonrpc.request("stop_suite", {})
      result["result"]
    end

  end

end
