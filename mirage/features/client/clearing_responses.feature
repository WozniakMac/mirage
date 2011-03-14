Feature: The client can be used for clearing responses from Mirage

  Background:
    Given the following code snippet is included when running code:
    """
    require 'rubygems'
    require 'rspec'
    require 'mirage'
    """
    And the response for 'greeting' is:
    """
    Hello
    """
    And getting 'greeting' with request body:
    """
    Hello there
    """
    And the response for 'leaving' is:
    """
    Goodbye
    """
    And getting 'greeting' with request body:
    """
    I'm going
    """

  Scenario: Clearing everything
    When run
    """
    Mirage::Client.new.clear
    """
    And getting 'greeting'
    Then a 404 should be returned
    And tracking the request for response id '1' should return a 404
    And getting 'leaving'
    Then a 404 should be returned
    And tracking the request for response id '1' should return a 404

  Scenario: Clearing all requests
    When run
    """
    Mirage::Client.new.clear :requests
    """
    Then tracking the request for response id '1' should return a 404
    And tracking the request for response id '2' should return a 404

  Scenario: Clearning a response
    Given run
    """
    Mirage::Client.new.clear 1
    """
    When getting 'greeting'
    Then a 404 should be returned
    And tracking the request for response id '1' should return a 404

  Scenario: Clearning a request
    Given run
    """
    Mirage::Client.new.clear :request => 1
    """
    Then tracking the request for response id '1' should return a 404





