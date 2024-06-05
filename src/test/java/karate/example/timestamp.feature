@Example
Feature: timestamp example

	Scenario: timestamp
		* def getDate =
      """
      function() {
      	var pattern = 'MM/dd/yyyy';
        var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
        var sdf = new SimpleDateFormat(pattern);
        var date = new java.util.Date();
        return date.getTime();
      }
      """
		* print getDate()
		* def timestamp = getDate()
		* match timestamp != null


	Scenario: Capture a year old date
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


	Scenario: Capture a x days old date
		* def pattern = 'yyyy-MM-dd'
		* def getDate =
      """
      function() {
        var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
        var sdf = new SimpleDateFormat(pattern);
        var date = new java.util.Date();
        return sdf.format(date);
      }
      """
		* def today = getDate()
		* def getSubtractedDays =
    """
    function(x) {
        var DateTimeFormatter = Java.type("java.time.format.DateTimeFormatter");
        var LocalDate = Java.type("java.time.LocalDate");
        var ChronoUnit = Java.type("java.time.temporal.ChronoUnit");
        var dtf = DateTimeFormatter.ofPattern(pattern);
        try {
          var adj = LocalDate.parse(today, dtf).minusDays(x);
          return dtf.format(adj);
        } catch(e) {
          karate.log('*** date parse error: ', today);
        }
      }
      """
		* def xDaysAgo = getSubtractedDays(2)
		* karate.log("x days ago is: " + xDaysAgo)