@Example
Feature: timestamp example

	Background:
	* def urlBase = '*********'
	* def DateUtil = Java.type('reqres_in_karate.utils.DateUtil')

	Scenario: timestamp
		* def getDate = DateUtil.getDate()
      	* print getDate
		* match getDate != null


	Scenario: Capture a year old date
		* def oneYearAgo = DateUtil.getSubtractedYear()
		* print oneYearAgo
		* match oneYearAgo != null
