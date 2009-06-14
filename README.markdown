# About Windmill

[Windmill](http://www.getwindmill.com/) is a web testing tool for automating and debugging web applications. This library provides a wrapper for interfacing with the Windmill API from Ruby. 

This Ruby gem provides a automatically generated wrapper layer around the Windmill [API](http://trac.getwindmill.com/wiki/ControllerApi). It uses the commands.getControllerMethods call to discover the methods and provides a one to one mapping for them. 

## Installation

Install Windmill according to the instruction available on the website. For interfacing to it from Ruby you need to install the windmill gem.

    $ sudo gem install windmill

## Running

To get up and running quickly, the first step is to start a Windmill session, for example one for Google.

    $ windmill run_service firefox http://google.com

This starts a Firefox instance with a Windmill IDE that goes to Google. From there it's possible to add steps manually to experiment with it. These steps can also be run from Ruby.

    require 'rubygems'
    require 'windmill'
    
    # Connect to the Windmill API
    session = Windmill::Client.new("http://localhost:4444/windmill-jsonrpc/")

    # Enter the test 'windmill testing framework' into the field named 'q'
    session.type(:name => 'q', :text => 'windmill testing framework')

    # You can also use stuff like the xpath matcher to find a button
    session.click(:xpath => "//button[.='Google Search']")
    
    # It also provides all assertions
    result = session.asserts.assertText(:name => 'q', :validator => 'windmill testing framework')
    
    # result now contains a hash with some information on whether the assertion was succesful,
    # when it was executed, etc. 
    # {"result"     => true, 
    #  "endtime"    => "2009-5-14T13:34:58.139Z",
    #  "method"     => "asserts.assertValue",
    #  "output"     => nil,
    #  "version"    => "0.1",
    #  "suite_name" => nil,
    #  "params"     => { "name"     => "q",
    #                    "validator"=> "windmill testing framework",
    #                    "uuid"=>"62704eec-58d7-11de-9509-001b639adff4"},
    #  "starttime"=>"2009-5-14T13:34:58.135Z"}
