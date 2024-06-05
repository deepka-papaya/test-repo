@Example
Feature: Post/Put/Patch/Delete Tests on reqres.in

	Background:

	* def urlBase = 'https://reqres.in'
	* def usersPath = '/api/users'	
    * def userPath = '/api/user/'
	
	
  Scenario: Validation

    * def diff =
      """
      function (X) {

      var C = false;
      for(var i = 0; i < X.length; i++) {
       C = X.email == "%"
      }
      return C;
      }
      """

    Given url urlBase + usersPath
		When method GET
		And path '/2'
		Then match responseStatus == 200
    * json temp = response
    * def sub = diff(temp.data)
    * match each sub == '#? _ == false'
    
    Scenario: parse invalidate number
    * def idNumber = parseInt('as10')
    * print idNumber
    * print typeof idNumber
    * match idNumber == NaN
    
    Scenario: parse validate number
    * def idNumber = parseInt('10')
    * print idNumber
    * match idNumber == '#number'
    
