@ignore
Feature: Reusable Post Tests on reqres.in

	Background:
	* def urlBase = 'https://reqres.in'
	* def usersPath = '/api/users'
	
	
	Scenario: Post user Data-Driven
	
		Given url  urlBase + usersPath 
		And request { name: '#(name)',job: '#(job)' }
		When method POST
		Then status 201
	