@Example
Feature: Get Tests on reqres.in

	Background:
	* def urlBase = 'https://reqres.in'
	* def usersPath = '/api/users'	
    * def userPath = '/api/user/'
	

	Scenario: Eval all users email
		Given url urlBase + usersPath
		When method GET
		And path '/2'
		Then match responseStatus == 200
		* def fun = function(array){ for (var i = 0; i < array.length; i++) karate.eval(array[i].email == '#regex [A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}') }
		* call fun response.data
		

	Scenario: karate.toBean test
	
		* def className = 'reqres_in_karate.beans.UserBean'
		Given url urlBase + usersPath
		When method GET
		Then match responseStatus == 200
		* def json = $.data[0]
		* def userBean = karate.toBean(json, className)
		* print userBean.getUserString()
		* match userBean.getUserString() == 'este es el string del bean: george.bluth@reqres.in'
	
	Scenario: json manipulation using string-replace
		Given url urlBase + usersPath
		When method GET
		Then match responseStatus == 200
		* def data = $.data[0]
		* replace data 
			|id	|email	|first_name		|last_name	|first_name 	|
			|1	|2		|3				|4			|5				|
		* json data = data
		* match data == {'id':1,'email':'george.bluth@reqres.in','first_name':'George','last_name':'Bluth','avatar':'https://reqres.in/img/faces/1-image.jpg'}
	
		
	Scenario: json path on a string should auto-convert
		Given url urlBase + usersPath
		When method GET
		Then match responseStatus == 200
		* def data = $.data
		* match data == [{"last_name":"Bluth","id":1,"avatar":"https:\/\/reqres.in\/img\/faces\/1-image.jpg","first_name":"George","email":"george.bluth@reqres.in"},{"last_name":"Weaver","id":2,"avatar":"https:\/\/reqres.in\/img\/faces\/2-image.jpg","first_name":"Janet","email":"janet.weaver@reqres.in"},{"last_name":"Wong","id":3,"avatar":"https:\/\/reqres.in\/img\/faces\/3-image.jpg","first_name":"Emma","email":"emma.wong@reqres.in"},{"last_name":"Holt","id":4,"avatar":"https:\/\/reqres.in\/img\/faces\/4-image.jpg","first_name":"Eve","email":"eve.holt@reqres.in"},{"last_name":"Morris","id":5,"avatar":"https:\/\/reqres.in\/img\/faces\/5-image.jpg","first_name":"Charles","email":"charles.morris@reqres.in"},{"last_name":"Ramos","id":6,"avatar":"https:\/\/reqres.in\/img\/faces\/6-image.jpg","first_name":"Tracey","email":"tracey.ramos@reqres.in"}]
		
		
	Scenario: arrays returned from js can be modified using 'set'
		Given url urlBase + usersPath
		When method GET
		Then match responseStatus == 200
		* def json = $.data
		* set json[0].first_name = 'Ana'
		* match json[0] == {'id':1,'email':'george.bluth@reqres.in','first_name':'Ana','last_name':'Bluth','avatar':'https://reqres.in/img/faces/1-image.jpg'}
	
	Scenario: json behaves like a java map within functions (will change with graal)
		Given url urlBase + usersPath
		When method GET
		Then match responseStatus == 200
		* def payload = $.data[0]
		* def f_keys = function(o){ return o.keySet() }
	    * def f_values = function(o){ return o.values() }
	    * def f_size = function(o){ return o.size() }
	    * def keys = f_keys(payload)
	    * def values = f_values(payload)
	    * def size = f_size(payload)
	    * match size == 5
	  
	  Scenario: set via json-path can be done in js
		Given url urlBase + usersPath
		When method GET
		Then match responseStatus == 200  
		* def json_user = response.data[0]
		* def json = { users: []}
		* karate.set('json', '$.users[]', json_user)
		* match json == { users: [{"id":1,"email":"george.bluth@reqres.in","first_name":"George","last_name":"Bluth","avatar":"https://reqres.in/img/faces/1-image.jpg"}]}
		
	Scenario: remove json key using keyword
		Given url urlBase + usersPath
		When method GET
		Then match responseStatus == 200  
		* def json = response.data[0]
		* remove json $.avatar
		* match json == {"id":1,"email":"george.bluth@reqres.in","first_name":"George","last_name":"Bluth"}
		
		
	Scenario: remove json key from js
		Given url urlBase + usersPath
		When method GET
		Then match responseStatus == 200  
		* def json = response.data[0]	
		* def fun = function(){karate.remove('json','$.avatar')}
		* call fun
		* match json == {"id":1,"email":"george.bluth@reqres.in","first_name":"George","last_name":"Bluth"}
	
	Scenario: set via table
		Given url urlBase + usersPath
		When method GET
		Then match responseStatus == 200  
		* def json = response.data[0]	
		* set json
		|path		|value	|
		|first_name	|'Ana'	|
		|id			|2		|
		* match json ==  {'id':2,'email':'george.bluth@reqres.in','first_name':'Ana','last_name':'Bluth','avatar':'https://reqres.in/img/faces/1-image.jpg'}
	
	Scenario: set via table and add a new path
		Given url urlBase + usersPath
		When method GET
		Then match responseStatus == 200  
		* def json = response.data[0]	
		* set json.cp
		|path		|value		|
		|company	|'Sngular'	|
		|cp			|41000		|
		* match json ==  {'id':1,'cp':{'company':'Sngular','cp':41000 },'email':'george.bluth@reqres.in','first_name':'George','last_name':'Bluth','avatar':'https://reqres.in/img/faces/1-image.jpg'}
		
		
	Scenario: karate.forEach() and js arguments (may change with graal)
	    * def vals = []
	    * def fun = function(){ karate.forEach(arguments, function(k, v){ vals.add(v) }) }
	    * print fun('a')
	    #* fun('a', 'b', 'c')
	    #* match vals == ['a', 'b', 'c']	
	    * match vals == ['a']	
		
	Scenario: lists - karate.sizeOf() keysOf() valuesOf() appendTo()
	   Given url urlBase + usersPath
		When method GET
		Then match responseStatus == 200  
		* def foo = response.data
	    * match karate.sizeOf(foo) == 6
	    * match karate.valuesOf(foo) == [{"last_name":"Bluth","id":1,"avatar":"https://reqres.in/img/faces/1-image.jpg","first_name":"George","email":"george.bluth@reqres.in"},{"last_name":"Weaver","id":2,"avatar":"https://reqres.in/img/faces/2-image.jpg","first_name":"Janet","email":"janet.weaver@reqres.in"},{"last_name":"Wong","id":3,"avatar":"https://reqres.in/img/faces/3-image.jpg","first_name":"Emma","email":"emma.wong@reqres.in"},{"last_name":"Holt","id":4,"avatar":"https://reqres.in/img/faces/4-image.jpg","first_name":"Eve","email":"eve.holt@reqres.in"},{"last_name":"Morris","id":5,"avatar":"https://reqres.in/img/faces/5-image.jpg","first_name":"Charles","email":"charles.morris@reqres.in"},{"last_name":"Ramos","id":6,"avatar":"https://reqres.in/img/faces/6-image.jpg","first_name":"Tracey","email":"tracey.ramos@reqres.in"}]
	    * def bar = karate.appendTo(foo, {"last_name":"x","id":9,"avatar":"x","first_name":"x","email":"x@reqres.in"})
	    * match foo == [{"last_name":"Bluth","id":1,"avatar":"https://reqres.in/img/faces/1-image.jpg","first_name":"George","email":"george.bluth@reqres.in"},{"last_name":"Weaver","id":2,"avatar":"https://reqres.in/img/faces/2-image.jpg","first_name":"Janet","email":"janet.weaver@reqres.in"},{"last_name":"Wong","id":3,"avatar":"https://reqres.in/img/faces/3-image.jpg","first_name":"Emma","email":"emma.wong@reqres.in"},{"last_name":"Holt","id":4,"avatar":"https://reqres.in/img/faces/4-image.jpg","first_name":"Eve","email":"eve.holt@reqres.in"},{"last_name":"Morris","id":5,"avatar":"https://reqres.in/img/faces/5-image.jpg","first_name":"Charles","email":"charles.morris@reqres.in"},{"last_name":"Ramos","id":6,"avatar":"https://reqres.in/img/faces/6-image.jpg","first_name":"Tracey","email":"tracey.ramos@reqres.in"},{"last_name":"x","id":9,"avatar":"x","first_name":"x","email":"x@reqres.in"}]
	    * match bar == [{"last_name":"Bluth","id":1,"avatar":"https://reqres.in/img/faces/1-image.jpg","first_name":"George","email":"george.bluth@reqres.in"},{"last_name":"Weaver","id":2,"avatar":"https://reqres.in/img/faces/2-image.jpg","first_name":"Janet","email":"janet.weaver@reqres.in"},{"last_name":"Wong","id":3,"avatar":"https://reqres.in/img/faces/3-image.jpg","first_name":"Emma","email":"emma.wong@reqres.in"},{"last_name":"Holt","id":4,"avatar":"https://reqres.in/img/faces/4-image.jpg","first_name":"Eve","email":"eve.holt@reqres.in"},{"last_name":"Morris","id":5,"avatar":"https://reqres.in/img/faces/5-image.jpg","first_name":"Charles","email":"charles.morris@reqres.in"},{"last_name":"Ramos","id":6,"avatar":"https://reqres.in/img/faces/6-image.jpg","first_name":"Tracey","email":"tracey.ramos@reqres.in"},{"last_name":"x","id":9,"avatar":"x","first_name":"x","email":"x@reqres.in"}]
	    * def bar = karate.appendTo(foo, {"last_name":"y","id":9,"avatar":"y","first_name":"y","email":"y@reqres.in"})
	    * match foo == [{"last_name":"Bluth","id":1,"avatar":"https://reqres.in/img/faces/1-image.jpg","first_name":"George","email":"george.bluth@reqres.in"},{"last_name":"Weaver","id":2,"avatar":"https://reqres.in/img/faces/2-image.jpg","first_name":"Janet","email":"janet.weaver@reqres.in"},{"last_name":"Wong","id":3,"avatar":"https://reqres.in/img/faces/3-image.jpg","first_name":"Emma","email":"emma.wong@reqres.in"},{"last_name":"Holt","id":4,"avatar":"https://reqres.in/img/faces/4-image.jpg","first_name":"Eve","email":"eve.holt@reqres.in"},{"last_name":"Morris","id":5,"avatar":"https://reqres.in/img/faces/5-image.jpg","first_name":"Charles","email":"charles.morris@reqres.in"},{"last_name":"Ramos","id":6,"avatar":"https://reqres.in/img/faces/6-image.jpg","first_name":"Tracey","email":"tracey.ramos@reqres.in"},{"last_name":"x","id":9,"avatar":"x","first_name":"x","email":"x@reqres.in"},{"last_name":"y","id":9,"avatar":"y","first_name":"y","email":"y@reqres.in"}]
	    * match bar == [{"last_name":"Bluth","id":1,"avatar":"https://reqres.in/img/faces/1-image.jpg","first_name":"George","email":"george.bluth@reqres.in"},{"last_name":"Weaver","id":2,"avatar":"https://reqres.in/img/faces/2-image.jpg","first_name":"Janet","email":"janet.weaver@reqres.in"},{"last_name":"Wong","id":3,"avatar":"https://reqres.in/img/faces/3-image.jpg","first_name":"Emma","email":"emma.wong@reqres.in"},{"last_name":"Holt","id":4,"avatar":"https://reqres.in/img/faces/4-image.jpg","first_name":"Eve","email":"eve.holt@reqres.in"},{"last_name":"Morris","id":5,"avatar":"https://reqres.in/img/faces/5-image.jpg","first_name":"Charles","email":"charles.morris@reqres.in"},{"last_name":"Ramos","id":6,"avatar":"https://reqres.in/img/faces/6-image.jpg","first_name":"Tracey","email":"tracey.ramos@reqres.in"},{"last_name":"x","id":9,"avatar":"x","first_name":"x","email":"x@reqres.in"},{"last_name":"y","id":9,"avatar":"y","first_name":"y","email":"y@reqres.in"}]
	    * match karate.sizeOf(foo) == 8
		
	Scenario: maps - karate.sizeOf() keysOf() valuesOf() appendTo()
		Given url urlBase + usersPath
		When method GET
		Then match responseStatus == 200  
		* def foo = response.data[0]
		* match karate.sizeOf(foo) == 5
		* print karate.keysOf(foo)
    	* match karate.keysOf(foo) == ['last_name','id','avatar','first_name','email']
    	* match karate.keysOf(foo) contains ['id','email','first_name','last_name','avatar']
		
		
	
		
		