@Example
Feature: Login and register Tests on reqres.in

	Background:
	* def urlBase = 'https://reqres.in'
	* def registerPath = '/api/register'
	* def loginPath = '/api/login'	
	
	Scenario: Post login successful
	
		Given url  urlBase + loginPath 
		And request { 'email': '#(username)', 'password': '#(password)' }
		When method POST
		Then response.status == '#(status)'