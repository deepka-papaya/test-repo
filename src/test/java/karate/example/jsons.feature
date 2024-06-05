@Example
Feature: Get Tests on reqres.in

	Background:
	* def urlBase = 'https://reqres.in'
	* def usersPath = '/api/users'	
    * def userPath = '/api/user/'
	
	

	Scenario: Check user name with get operator
	
		Given url urlBase + usersPath
		When method GET
		And path '/2'
		Then match responseStatus == 200
		* def initialName = 'George'
		* def evaluate = get[0] response.data[*].first_name 
		* print evaluate
		* match initialName == get[0] response.data[*].first_name
		
	Scenario: Check user email with get operator
	
		Given url urlBase + usersPath
		When method GET
		And path '/2'
		Then match responseStatus == 200
		* def pattern = 'george.bluth@reqres.in'
		* def evaluate = get[0] response.data[*].email
		* print evaluate
		* match pattern contains get[0] response.data[*].email

	Scenario: Check validate user email with contains each operator
	
		Given url urlBase + usersPath
		When method GET
		And path '/2'
		Then match responseStatus == 200
		* match each response.data contains {email: '#regex [A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}'}
		
	Scenario: Check number of user data 
	
		Given url urlBase + usersPath
		When method GET
		#And path '/2'
		Then match responseStatus == 200
		* match each response.data contains {id: '#number'}
		* match each response.data contains {isd: '#notpresent'}
		* match response.data == '#[6]'
		
	Scenario: Check validate user email with a function

		Given url urlBase + usersPath
		When method GET
		And path '/2'
		Then match responseStatus == 200
		* def validateEmail = function(x){return x.email.matches(".*@reqres.in.*")}
		* print validateEmail
		* match each response.data == '#? validateEmail(_)'
		
	Scenario: convert array of primitives into array of objects
	
	Given url urlBase + usersPath
	When method GET
	#And path '/2'
	Then match responseStatus == 200
	* def list = get response.data[*].first_name
	* print list
    * def data = karate.mapWithKey(list, 'name')
    * match data == [{ name: 'George' }, { name: 'Janet' }, { name: 'Emma' }, { name: 'Eve' }, { name: 'Charles' }, { name: 'Tracey' }]

	Scenario: convert an array into a different shape
    Given url urlBase + usersPath
	When method GET
	#And path '/2'
	Then match responseStatus == 200
	* def list = get response.data[*].first_name
	* print list
    * def data = karate.mapWithKey(list, 'name')
    * print data
    * def fun = function(x){ return { nombre: x.name } }
    * def after = karate.map(data, fun)
    * print after 
    * match after ==  [{ nombre: 'George' }, { nombre: 'Janet' }, { nombre: 'Emma' }, { nombre: 'Eve' }, { nombre: 'Charles' }, { nombre: 'Tracey' }]

    
    
    Scenario: karate filter operation
    Given url urlBase + usersPath
	When method GET
	#And path '/2'
	Then match responseStatus == 200
	* def list = get response.data[*].first_name
	* print list
    * def fun = function(x){ return x.indexOf('a') != -1 }
    * def res = karate.filter(list, fun)
    * print res
    * match res == ["Janet","Emma","Charles","Tracey"]
    
    Scenario: forEach works even on object key-values, not just arrays
    
    Given url urlBase + usersPath
	When method GET
	#And path '/2'
	Then match responseStatus == 200
    * def keys = []
    * def vals = []
    * def idxs = []
    * def fun = 
    """
    function(x, y, i) { 
      karate.appendTo(keys, x); 
      karate.appendTo(vals, y); 
      karate.appendTo(idxs, i); 
    }
    """
     Given url urlBase + usersPath
	When method GET
	#And path '/2'
	Then match responseStatus == 200
	* def map = get[0] response.data[*]
	* print map
    * karate.forEach(map, fun)
    * match keys ==  ["last_name","id","avatar","first_name","email"]
    * match vals == ["Bluth",1,"https://reqres.in/img/faces/1-image.jpg","George","george.bluth@reqres.in"], expected: ["George","Janet","Emma","Eve","Charles","Tracey"]
    * match idxs == [0,1,2,3,4]
    
    
    Scenario: Post user
	
		Given url  urlBase + usersPath
		* def fun = function(i){ return { name: 'User ' + (i + 1) , job : 'leader ' + (i + 1)}}
		* def foo = karate.repeat(1, fun)
		And request foo[0]
		When method POST
		Then status 201
		* print response
		And match response == {'name': '#string','job': '#string','id': '#notnull','createdAt': '#notnull'}
    
    Scenario Outline: Post user with functions not run
	
		Given url  urlBase + usersPath
		* def fun = function(i){ return { name: 'User ' + (i + 1) , job : 'leader ' + (i + 1)}}
		* def foo = karate.repeat(3, fun)
		And def user = 
		"""
		{
			"name":'<name>',
			"job":'<job>'
		}
		"""
		And request user
		When method POST
		Then status 201
		* print response
		And match response == {'name': '#string','job': '#string','id': '#notnull','createdAt': '#notnull'}
		Examples:
		|name		|job		|
		|foo[0].name|foo{0}.job	|
		|foo[1].name|foo{1}.job	|
		|foo[2].name|foo{2}.job	|
		
		
	Scenario: Get users list and check match each 
	
		Given url urlBase + usersPath
		When method GET
		Then match responseStatus == 200
		* def fun = function(x){ return {name : x.first_name} }
		* print response.data
		* def res = karate.map(response.data, fun)
		* print res
		* match res == [{name:'George'}, {name:'Janet'}, {name:'Emma'}, {name:'Eve'}, {name:'Charles'}, {name:'Tracey'}]
	