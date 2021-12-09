public with sharing class LC_OpportunityRecordController {             
    @AuraEnabled
    public static List<sObject> getRecords(String sObjectName,String fieldList, Integer numberOfRecords){
    	//User userRecord = [SELECT Name,Owned__c,Owned_Products__c,View_All_Products_Centers__c FROM User WHERE Id = :UserInfo.getUserId()]; 
        List<sObject> lstResult = new List<sObject>();
        /*List<String> Owned_Products = new List<String>();
        List<String> Owned_Centers = new List<String>(); 
        if(userRecord.Owned_Products__c != Null){
        for(String op : userRecord.Owned_Products__c.split(';')){
            Owned_Products.add(op);  
        }} 
        if(userRecord.Owned__c != Null){
        for(String oc : userRecord.Owned__c.split(';')){
            Owned_Centers.add(oc);
        }}
        try{           
            List<String> fieldNames = (List<String>) JSON.deserialize(fieldList, List<String>.class);        
            String query = 'SELECT ' + String.join(fieldNames, ','); 
            if(userRecord.View_All_Products_Centers__c){                 
                query +=',Account.Name FROM ' + sObjectName + ' WHERE (IsClosed = False AND IsWon = False) AND Opportunity_LOB__c = \'CIB\' LIMIT ' + numberOfRecords;             
            }
            else{
                if(userRecord.Owned_Products__c != Null && userRecord.Owned__c != Null){ 
                    query +=',Account.Name FROM ' + sObjectName + ' WHERE (IsWon = False AND IsClosed = False) AND (STI_Product__c IN :Owned_Products OR Home_Centre_Current__c IN :Owned_Centers) LIMIT ' + numberOfRecords;              
                }else if(userRecord.Owned__c != Null){
                    query +=',Account.Name FROM ' + sObjectName + ' WHERE (IsWon = False AND IsClosed = False) AND Home_Centre_Current__c IN :Owned_Centers LIMIT ' + numberOfRecords;  
                }else if(userRecord.Owned_Products__c != Null){ 
                    query +=',Account.Name FROM ' + sObjectName + ' WHERE (IsWon = False AND IsClosed = False) AND STI_Product__c IN :Owned_Products LIMIT ' + numberOfRecords;  
                }
            }
            system.debug('Query--> '+query);
			lstResult=Database.query(query);
        }catch(Exception exc){
            system.debug('Exception= '+exc.getLineNumber() + ' : ' + exc.getMessage());
        } */       
        return lstResult;
    }  
    @AuraEnabled
    public static String getFields(String typeName, String fsName) {        
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(typeName);
        Schema.DescribeSObjectResult describe = targetType.getDescribe();
        Map<String, Schema.FieldSet> fsMap = describe.fieldSets.getMap();       
        Schema.FieldSet fs = fsMap.get(fsName); 
        
        List<Schema.FieldSetMember> fieldSet = fs.getFields();
        List<FieldSetMember> fset = new List<FieldSetMember>();
        Integer i= 1;
        for (Schema.FieldSetMember f: fieldSet) { 
            fset.add(f);
            i++;
        }        
        return JSON.serialize(fset);   
    }      
    @AuraEnabled
    public static String getURL(){      
        return URL.getSalesforceBaseUrl().getHost();        
    }    
}