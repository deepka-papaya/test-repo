@ignore
Feature: Reusable function to capture info about the date

  # Example:
  # * def dateResponse = call read('classpath:features/test_getdate.feature')
  # * def todaysDate = dateResponse.today
  # * def lastYearDate = dateResponse.oneYearAgo

  Background: Setup
    * def pattern = 'MM/dd/yyyy'
    * def getDate =
      """
      function() {
        var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
        var sdf = new SimpleDateFormat(pattern);
        var date = new java.util.Date();
        return sdf.format(date);
      } 
      """

  Scenario: Capture todays date
    * def today = getDate()
    * karate.log("Today's date is: " + today )

  Scenario: Capture a year old date
    * def today = getDate()
    * def getSubtractedYear =
    """
    function(s) {
        var DateTimeFormatter = Java.type("java.time.format.DateTimeFormatter");
        var LocalDate = Java.type("java.time.LocalDate");
        var ChronoUnit = Java.type("java.time.temporal.ChronoUnit");
        var dtf = DateTimeFormatter.ofPattern(pattern);
        try {
          var adj = LocalDate.parse(today, dtf).minusMonths(12);
          return dtf.format(adj);
        } catch(e) {
          karate.log('*** date parse error: ', s);
        }
      } 
      """
    * def oneYearAgo = getSubtractedYear()
    * karate.log("One year ago is: " + oneYearAgo)
    
   Scenario: Convert date to long
    * def getTime =
    """
    function(date) {
          var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
	      var sdf = new SimpleDateFormat("dd-MM-yyyy");
	      karate.log('long date: '+date);
	      karate.log('long date: '+date);
	      return sdf.parse(date).time  
      } 
      """