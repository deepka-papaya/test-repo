@Example
Feature: Get Tests on reqres.in

	Background:
	* def urlBase = 'https://reqres.in'
	* def usersPath = '/api/users'	
    * def userPath = '/api/user/'
    * def usersJson = read('../examples/usersJson.csv')
	
	
	Scenario Outline: scenario outline using a dynamic table to user name: <name> and job: <job>
	    
	    Given url  urlBase + usersPath 
		And request { 'name': '<name>','job': '<job>' }
		When method POST
		Then status 201
	    And match response == { id: '#string', name: '<name>', job: '<job>', createdAt: '#notnull' }
	    Examples:
	    | usersJson |
	    
	Scenario Outline: scenario outline to call
	    
	    Given url  urlBase + usersPath 
		And request { 'name': '<name>','job': '<job>' }
		When method POST
		Then status 201
	    And match response == { id: '#string', name: '<name>', job: '<job>', createdAt: '#notnull' }
	    Examples:
	    | usersJson |