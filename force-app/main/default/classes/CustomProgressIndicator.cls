public with sharing class CustomProgressIndicator {
	@AuraEnabled(cacheable=true)
    public static List<CustomStepDetail__mdt> getStepDetails(String ProcessName){
        List<CustomStepDetail__mdt> stepDetails = [SELECT Step_Value__c, Step_Label__c,Screen_Order__c FROM CustomStepDetail__mdt WHERE ProcessName__c = :ProcessName ORDER BY Screen_Order__c ASC NULLS LAST];
        return stepDetails;
    }
}