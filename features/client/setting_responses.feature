Feature: the Mirage client provides methods for setting responses and loading default responses.
  There is no need to escape any parameters before using the client api as this is done for you.

  Background:
    Given the following gems are required to run the Mirage client test code:
    """
    require 'rubygems'
    require 'rspec'
    require 'mirage'
    """

  Scenario: Setting a basic response
    Given I run
    """
    Mirage::Client.new.set('greeting',:response => 'hello')
    """
    When I hit 'http://localhost:7001/mirage/get/greeting'
    Then 'hello' should be returned

  Scenario: Setting a response with a pattern
    Given I run
    """
    Mirage::Client.new.set('greeting', :response => 'Hello Leon', :pattern => '.*?>leon</name>')
    """
    When I hit 'http://localhost:7001/mirage/get/greeting'
    Then a 404 should be returned
    When I hit 'http://localhost:7001/mirage/get/greeting' with request body:
    """
     <greetingRequest>
      <name>leon</name>
     </greetingRequest>
    """
    Then 'Hello Leon' should be returned

  Scenario: Loading default responses
    Given Mirage is not running
    And I run 'mirage start'

    When the file 'defaults/default_greetings.rb' contains:
    """
    Mirage.default do |mirage|
      mirage.set('greeting', :response => 'hello')
      mirage.set('leaving', :response => 'goodbye')
    end
    """
    And I run
    """
    Mirage::Client.new.load_defaults
    """
    And I hit 'http://localhost:7001/mirage/get/greeting'
    Then 'hello' should be returned

    When I hit 'http://localhost:7001/mirage/get/leaving'
    Then 'goodbye' should be returned


  Scenario: Setting defaults and one of the files has something bad in it
    Given the file 'defaults/default_greetings.rb' contains:
    """
    Something bad...
    """
    When I run
    """
    begin
      Mirage::Client.new.load_defaults
      fail("Error should have been thrown")
    rescue Exception => e
      e.is_a?(Mirage::InternalServerException).should == true
    end
    """


  Scenario: Setting a file as a response
    Given I run
    """
    Mirage::Client.new.set('download', :file => File.open('features/resources/test.zip'))
    """
    When I hit 'http://localhost:7001/mirage/get/download'
    Then the response should be a file the same as 'features/resources/test.zip'


  Scenario: A response or file is not supplied
    Given I run
    """
      begin
        Mirage::Client.new.set('download',{})
        fail("Error should have been thrown")
      rescue Exception => e
        e.is_a?(Mirage::InternalServerException).should == true
      end
    """