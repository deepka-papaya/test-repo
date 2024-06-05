@Example
Feature: Get Tests on reqres.in

	Background:
	* def urlBase = 'https://reqres.in'
	* def usersPath = '/api/users'	
    * def userPath = '/api/user/'
    * def usersJson2 = read('../examples/usersJson2.csv')
	
	
	 Scenario Outline:  Operation dinamic call
	 
	  Given def path = 'classpath:examples/outline.feature'
      * print path
      * def signIn = call read(path)  { 'name': <name> , 'job': <job>, 'status':<status_code> }
	  * print signIn
      Then match signIn.status == <status_code>
      
      Examples:
          | usersJson2 |
	