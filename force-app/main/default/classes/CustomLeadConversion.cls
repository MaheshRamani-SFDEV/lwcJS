public with sharing class CustomLeadConversion {
    @AuraEnabled(cacheable=true)
    public static List<wrapp> getStepDetails(String ProcessName){
        System.debug('@@@Mahesh:ProcessName>>>>>>>>>>>>>> '+ProcessName);
        List<wrapp> stepDetails = new List<wrapp>();
        for(CustomStepDetail__mdt param :  [SELECT Step_Value__c, Step_Label__c,Screen_Order__c FROM CustomStepDetail__mdt WHERE ProcessName__c = :ProcessName ORDER BY Screen_Order__c ASC NULLS LAST])
        {
            system.debug('param--->>>>> '+param);
            wrapp obj = new wrapp(param.Step_Label__c,param.Step_Value__c);
            stepDetails.add(obj); 
        }
        system.debug('stepDetails--->>>>> '+stepDetails);
        return stepDetails;
    }

    public class wrapp{
        @AuraEnabled
        public String label{get;set;}
        @AuraEnabled
        public String value{get;set;}
        
        public wrapp(String stepLabel, String stepValue){
            this.label = stepLabel;
            this.value = stepValue;           
        }
    }
}