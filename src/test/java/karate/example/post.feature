@Example
Feature: Post/Put/Patch/Delete Tests on reqres.in

	Background:
	* def urlBase = 'https://reqres.in'
	* def usersPath = '/api/users'
	* def usersJson = read('../examples/usersJson2.csv')

	
	Scenario: Post user
	
		Given url  urlBase + usersPath 
		And request { 'name': 'morpheus','job': 'leader' }
		When method POST
		Then status 201
		And match response == {'name': 'morpheus','job': 'leader','id': '#notnull','createdAt': '#notnull'}
	
	Scenario: Put user
	
		Given url  urlBase + usersPath + '/2'
		And request { 'name': 'morpheus updated','job': 'leader updated' }
		When method PUT
		Then status 200
		And match $.name == 'morpheus updated'	
		
	Scenario: Patch user
	
		Given url  urlBase + usersPath + '/2'
		And request { 'name': 'morpheus','job': 'zion resident' }
		When method PATCH
		Then status 200
		And match $.job == 'zion resident'
		And match $.updatedAt == '#notnull'
	
	Scenario: Delete user
	
		Given url  urlBase + usersPath + '/2'
		When method DELETE
		Then status 204	
		
	Scenario Outline: scenario outline using a dynamic table to user name: <name> and job: <job>
		    Given url  urlBase + usersPath
			And request { 'name': '<name>','job': '<job>' }
			When method POST
			Then status 201
		    And match response == { id: '#string', name: '<name>', createdAt:'#notnull', job:'<job>' }

		    # the single cell can be any valid karate expression
		    # and even reference a variable defined in the Background
		    Examples:
		    | usersJson |