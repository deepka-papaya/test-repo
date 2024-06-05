@ignore
Feature: Delete Tests on reqres.in 

	Background:
	* def urlBase = 'https://reqres.in'
	* def usersPath = '/api/users'

	Scenario: Delete user
		* print ids
		* def path = urlBase + usersPath +'/' + id
		* print path 
		Given  url path
		When method DELETE
		Then status 204	