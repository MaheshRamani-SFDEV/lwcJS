public with sharing class CustomCompareController {
   
    /**
     * @Description: fetching custom metadata details for compare fields
     * */
	@AuraEnabled(cacheable=true)
    public static list<CustomCompareFieldWrapper> getCompareFields(String processName, String objectName){
        
        List<CustomCompareFieldWrapper> compareWrapList= new List<CustomCompareFieldWrapper>();
        System.debug('##ProcessName>>>>>>>>>'+processName);  
         System.debug('##objectName>>>>>>>>>'+objectName);
    	
        for(CustomCompareFieldDetail__mdt compareMetadataObj :  [SELECT Id,Label,DeveloperName,ProcessName__c,Object1__c,Object1_Field_API__c,Object1_Field_Type__c,
                                                            Object2__c,Object2_Field_API__c,Object2_Field_Type__c, Field_Order__c,
                                                            Is_Object1_Field_Editable__c                                                    	
                                                            FROM CustomCompareFieldDetail__mdt 
                                                    WHERE ProcessName__c = :processName  
                                                    AND Object2__c = :objectName
                                                    ORDER BY Field_Order__c 
                                                    ASC NULLS LAST])
        {          
                       
            compareWrapList.add(new CustomCompareFieldWrapper(compareMetadataObj));
            
        }
        System.debug('## Compare Metadata fieldDetails>>>>>>>>>'+compareWrapList);
        return compareWrapList;
    }


   
    /*
     * @Description: Wrapper class for compare fields
     * 
     * */
    public class CustomCompareFieldWrapper{
        @AuraEnabled
        public String id{get;set;}
        @AuraEnabled
        public String field1Name{get;set;}
        @AuraEnabled
        public String field2Name{get;set;}
        @AuraEnabled
        public boolean isField1Selected{get;set;}
        @AuraEnabled
        public boolean isField2Selected{get;set;}
        @AuraEnabled
        public CustomCompareFieldDetail__mdt compareRecord {get;set;}
        
        
        public CustomCompareFieldWrapper(CustomCompareFieldDetail__mdt compareRecord){  
            this.compareRecord = compareRecord;
            this.id= compareRecord.Id;          
            this.isField1Selected = false;
            this.isField2Selected = false;  
            this.field1Name = compareRecord.Id+'#'+compareRecord.Object1_Field_API__c+'#1';
            this.field2Name = compareRecord.Id+'#'+compareRecord.Object2_Field_API__c+'#2';         
        }
    }

}