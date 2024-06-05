@Example
Feature: Post Tests on reqres.in examples

	Background:
	* def urlBase = 'https://reqres.in'
	* def usersPath = '/api/users'
	
	
	Scenario: date comparation
		Given url  urlBase + usersPath 
		And request { name: 'John',job: 'leader' }
		When method POST
		Then status 201
		* def toTime =
		    """
		    function(s) {
		      var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
		      var sdf = new SimpleDateFormat("dd-MM-yyyy");
		      return sdf.parse(s).time           
		    }
		    """ 
		* print response
		* def date = response.createdAt
		* def today = new java.util.Date().time
		* assert today > toTime(date)
	
	Scenario: date comparation from config
		Given url  urlBase + usersPath 
		And request { name: 'John',job: 'leader' }
		When method POST
		Then status 201
		* def date = response.createdAt
		* def today = new java.util.Date().time
		* def util =  call read('date.feature')
		* def longDate = util.getTime(date)
		* assert today > longDate
	