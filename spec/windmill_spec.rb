require 'jsonrpc'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'windmill'))

# Mock around Net::HTTP so we don't need a real connection.
# We just verify whether the correct data is posted and return
# know test data

class Net::HTTP < Net::Protocol
  def connect
  end
end

class Net::HTTPResponse
  def body=(content)
    @body = content
    @read = true
  end
end

class Net::HTTP < Net::Protocol

  def self.raw_response_data
    @raw_response_data
  end

  def self.raw_response_data=(data)
    @raw_response_data = data
  end

  def self.raw_post_body=(body)
    @raw_post_body = body
  end

  def self.raw_post_body
    @raw_post_body
  end

  def self.raw_post_path=(path)
    @raw_post_path = path
  end

  def self.raw_post_path
    @raw_post_path
  end

  def post(path, body, headers = [])
    res = Net::HTTPSuccess.new('1.2', '200', 'OK')
    self.class.raw_post_path = path
    self.class.raw_post_body = body
    res.body = self.class.raw_response_data
    res
  end
end

describe Windmill::Client do

  before do
    Net::HTTP.raw_response_data = '{"result": {"status": true, "version": "0.1", "suite_name": "__main__",
                                      "result": ["click","waits.forJS","asserts.assertText"],
                                        "params": {"uuid":"123"},
                                        "method": "commands.getControllerMethods"}, "id": "1"}'
    @windmill = Windmill::Client.new("http://localhost:4444/api")
  end

  # Not supported atm
  it { @windmill.should respond_to(:start_suite) }
  it { @windmill.should respond_to(:stop_suite) }
  #it { @windmill.should respond_to(:add_object) }
  #it { @windmill.should respond_to(:add_json_test) }
  #it { @windmill.should respond_to(:add_test) }
  #it { @windmill.should respond_to(:add_json_command) }
  #it { @windmill.should respond_to(:add_command) }
  #it { @windmill.should respond_to(:execute_object) }
  #it { @windmill.should respond_to(:execute_json_command) }
  #it { @windmill.should respond_to(:execute_json_test) }

  it { @windmill.should respond_to(:execute_command) }
  it { @windmill.should respond_to(:execute_test) }

  # It should also respond to methods defined in the API
  it { @windmill.should respond_to(:waits) }
  it { @windmill.should respond_to(:asserts) }
  it { @windmill.should respond_to(:click) }
  it { @windmill.waits.should respond_to(:forJS) }
  it { @windmill.asserts.should respond_to(:assertText) }

  describe 'execute_command' do

    before do
      Net::HTTP.raw_response_data = '{"result": {"status": true, "version": "0.1", "suite_name": "__main__",
                                        "result": ["click","waits.forJS","asserts.assertText"],
                                          "params": {"uuid":"123"},
                                          "method": "commands.getControllerMethods"}, "id": "1"}'
      @windmill = Windmill::Client.new("http://localhost:4444/api")
      @result = @windmill.execute_command(:method => "commands.getControllerMethods")
    end

    it 'should correctly run the command' do
      @result.should == {"status" => true, "version" => "0.1", "suite_name" => "__main__", "result" => ["click","waits.forJS","asserts.assertText"],
                                          "params" => {"uuid" => "123"},
                                          "method" => "commands.getControllerMethods"}
    end

  end

  describe 'start_suite' do

    before do
      Net::HTTP.raw_response_data = '{"result": {"status": true, "version": "0.1", "suite_name": "__main__",
                                        "result": ["click","waits.forJS","asserts.assertText"],
                                          "params": {"uuid":"123"},
                                          "method": "commands.getControllerMethods"}, "id": "1"}'
      @windmill = Windmill::Client.new("http://localhost:4444/api")
      @result = @windmill.start_suite('test_suite')
    end

    it 'should correctly run the command' do
      JSON.parse(Net::HTTP.raw_post_body).should == JSON.parse('{"method":"start_suite","params":{"suite_name":"test_suite"}}')
    end

  end


  describe 'stop_suite' do

    before do
      Net::HTTP.raw_response_data = '{"result": {"status": true, "version": "0.1", "suite_name": "__main__",
                                        "result": ["click","waits.forJS","asserts.assertText"],
                                          "params": {"uuid":"123"},
                                          "method": "commands.getControllerMethods"}, "id": "1"}'
      @windmill = Windmill::Client.new("http://localhost:4444/api")
      @result = @windmill.stop_suite
    end

    it 'should correctly run the command' do
      JSON.parse(Net::HTTP.raw_post_body).should == JSON.parse('{"method":"stop_suite","params":{}}')
    end

  end

  describe 'executing a generated method' do

    before do
      Net::HTTP.raw_response_data = '{"result": {"version": "0.1", "suite_name": "__main__", "result": true,
                                                 "starttime": "2008-11-19T14:29:48.658Z",
                                                 "params": {"link": "People", "uuid": "1b38d526-cdd1-11dd-87e4-001ec20a547b"},
                                                 "endtime": "2008-11-19T14:29:48.661Z", "method": "click"},
                                      "id": "1"}'
      @windmill = Windmill::Client.new("http://localhost:4444/api")
      @result = @windmill.click(:link => "People")
    end

    it 'should generate the correct JSON request' do
      JSON.parse(Net::HTTP.raw_post_body).should == JSON.parse('{"method":"execute_test","params":{"action_object":{"method":"click","params":{"link":"People"}}}}')
    end

  end

end
