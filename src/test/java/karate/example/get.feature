@Example
Feature: Get Tests on reqres.in

 	Background:
   	* def urlBase = 'https://reqres.in'
   	* def usersPath = '/api/users'	
    * def userPath = '/api/user/'
    * def colorsPath = '/api/colors/'
    * def colorPath = '/api/color/'
	
	
 	Scenario: Get users list
	
  		Given url  urlBase + usersPath + '?page=2'
  		When method GET
  		Then status 200
		
 	Scenario: Get users list with param
	
  		Given url  urlBase + usersPath
  		And param page = 2
  		When method GET
  		Then status 200
		
 	Scenario: Get users list and check value in field
	
  		Given url urlBase + usersPath
  		When method GET
  		Then status 200
  		And match $..first_name contains 'Emma'
		
 	Scenario: Get existent user and check match contains any
	
  		Given url urlBase + usersPath
  		When method GET
  		Then match responseStatus == 200
  		And match $..id contains any 2
	
 	Scenario: Get existent user and check match !contains
	
  		Given url urlBase + usersPath
  		When method GET
  		Then match responseStatus == 200
  		And match $..id !contains 8

 	Scenario: Get existent user with validate email
	
  		Given url urlBase + usersPath
  		When method GET
  		And path '/2'
  		Then match responseStatus == 200
  		And match $..email contains '#regex .*@reqres.in.*'
		
 	Scenario: Get existent user with validate email with pattern
	
  		Given url urlBase + usersPath
  		When method GET
  		And path '/2'
  		Then match responseStatus == 200
  		And match $..email contains  '#regex [A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}'
	
 	Scenario: Print all users email
  		Given url urlBase + usersPath
  		When method GET
  		And path '/2'
  		Then match responseStatus == 200
  		* def fun = function(array){ for (var i = 0; i < array.length; i++) karate.log(array[i].email) }
  		* call fun response.data
	
		
 	Scenario: Get user with path param
	
  		Given url urlBase + usersPath
  		When method GET
  		And path '/2'
  		Then status 200
  		And match $..id contains 2
	
 	Scenario: Get existent user
	
  		Given url urlBase + userPath + '2'
  		When method GET
  		Then status 200
	
 	Scenario: Get existent user and check status response
	
  		Given url urlBase + userPath + '2'
  		When method GET
  		Then match responseStatus == 200
		
			
 	Scenario: Get non-existent user
	
  		Given url urlBase + userPath + '123456'
  		When method GET
  		Then status 404
	
 	Scenario: Get color list
	
  		Given url  urlBase + colorsPath + '?page=2'
  		When method GET
  		Then status 200
  		And match $.data.length() == 6
	
 	Scenario: Get existent color
	
  		Given url urlBase + colorPath + '2'
  		When method GET
  		Then status 200
  		And match $.data.id == 2
  		And match $.data.name == 'fuchsia rose'
	
 	Scenario: Get non-existent color
	
  		Given url urlBase + colorPath + '123456'
  		When method GET
  		Then status 404
	