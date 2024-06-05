@Example
Feature: Data-Driven Tests on reqres.in

	Scenario: call post with Data-Driven 
    
	* table users
	|name		|job		|
	|'max' 		|'tester1'	|
	|'maggie' 	|'tester2'	|
	|'sammy' 	|'tester3'	|
	
	* def result = call read('post2.feature') users
	* def created = $result[*].response
	* match each created == {'name': '#string','job': '#string','id': '#notnull','createdAt': '#notnull'}
	* match created[*].name contains only ['max' ,'maggie','sammy']
	
	Scenario: call post with Data-Driven and delete with conditional operation
    
	* table users
	|name		|job		|
	|'max' 		|'tester1'	|
		
	* def result = call read('post2.feature') users
	* def id = result[0].response.id
	* table ids
	|id|
	|id|
	* def res = result.responseStatus == 201 ? {} : karate.call('delete.feature', ids)
	
	