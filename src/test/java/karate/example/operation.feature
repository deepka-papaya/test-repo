@Example
Feature: Login and register Tests on reqres.in

	Background:
	* def urlBase = 'https://reqres.in'
	* def registerPath = '/api/register'
	* def loginPath = '/api/login'
	
	Scenario: Post register successful
	
		Given url  urlBase + registerPath 
		And request { 'email': 'eve.holt@reqres.in', 'password': 'pistol' }
		When method POST
		Then status 200
	
	Scenario: Post register unsuccessful
	
		Given url  urlBase + registerPath 
		And request { 'email': 'eve.holt@reqres.in' }
		When method POST
		Then status 400
		And match $.error == 'Missing password'
	
	Scenario: Post login successful
	
		Given url  urlBase + loginPath 
		And request { 'email': 'eve.holt@reqres.in', 'password': 'cityslicka' }
		When method POST
		Then status 200
		And match $.token == 'QpwL5tke4Pnpja7X4'
	
	Scenario: Post login unsuccessful
	
		Given url  urlBase + loginPath 
		And request { 'email': 'eve.holt@reqres.in' }
		When method POST
		Then status 400
		And match $.error == 'Missing password'
		
	Scenario Outline:   As a <description>, I want to get the corresponding response_code <status_code>
      Given url  urlBase + loginPath 
      And request { 'email': <username> , 'password': <password> }
	  When method POST
      * print response
      Then response.status == <status_code>


      Examples:
           |username       			|password		| status_code| description |
           |'eve.holt@reqres.in'	|'cityslicka'	| 200        | valid user  |
           |'eve.holt@reqres.in'    |null    		| 400        | invalid user|
           
    Scenario Outline:  Operation call:  As a <description>, I want to get the corresponding response_code <status_code>
      Given def path = 'classpath:examples/my-signin.feature' 
	  * def signIn = call read(path)  { 'email': <username> , 'password': <password>, 'status':<status_code> }
	  * print signIn
      Then match signIn.status == <status_code>
      And match signIn.token == '<token>'


      Examples:
           |username       			|password		| status_code| description |token 				|
           |'eve.holt@reqres.in'	|'cityslicka'	| 200        | valid user  |QpwL5tke4Pnpja7X4	|
           |'eve.holt@reqres.in'    |null    		| 400        | invalid user|null				|
           
       