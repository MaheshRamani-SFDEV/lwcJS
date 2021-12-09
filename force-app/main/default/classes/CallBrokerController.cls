public with sharing class CallBrokerController {
    
    @AuraEnabled
    public static Broker__c saveBrokerWithEvent(Broker__c broker) {
        insert broker;
        return broker;
    }
        
    @AuraEnabled
    public static Broker__c getBroker(String RecId){
	
        Broker__c broker = new Broker__c();
        try{
            
            if(RecId != null)
            {
               // Event eventObj = [SELECT Id, WhatId,OwnerId ,Subject,CurrencyIsoCode FROM Event WHERE Id =: RecId ];        
                ObjectInfo__mdt objectmdt = [SELECT MasterLabel, FieldApiNames__c, ObjectApiName__c, filterField__c From ObjectInfo__mdt where ObjectApiName__c='Event'];
            	String query = 'select '+objectmdt.FieldApiNames__c+ ' from ' + objectmdt.ObjectApiName__c + ' where ' + objectmdt.filterField__c + '=\''+RecId+'\''; 
                Event eventObj = Database.query(query);
                system.debug('event object is:'+eventObj);
                for(String f :objectmdt.FieldApiNames__c.split(',')){
                    System.debug('Field name is: '+ f);
                }
                if(eventObj.Subject.length() > 80)    
                {      
                    broker.Name = eventObj.Subject.substring(0,80);     
                }
                else
                {
                    broker.Name = eventObj.Subject;
                }
                
                broker.ownerId = eventObj.OwnerId; 
                broker.CurrencyIsoCode = eventObj.CurrencyIsoCode; 
                // if(eventObj.WhatId != NULL && ((String)eventObj.WhatId).StartsWith(ConstantsClass.STARTS_WITH_006)){           
                broker.Deal__c = eventObj.WhatId;
                Opportunity oppObj= [SELECT AccountId FROM Opportunity WHERE Id =:eventObj.WhatId ];
                Id accntId = oppObj.AccountId;   
                broker.Account__c = accntId;                              
                
                // }               
            }
        }catch(exception e) {
            system.debug('Eror is:'+e.getmessage());
        }     
        return broker;
        
    }
        @AuraEnabled
    public static List<String> getPicklistvalues(String objectName, String field_apiname,Boolean nullRequired, String defaultValue){
        List<String> optionlist = new List<String>();
        
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Map<String, Schema.SObjectField> field_map = gd.get(objectName.toLowerCase()).getDescribe().fields.getMap(); 
        
        List<Schema.PicklistEntry> picklistValues = field_map.get(field_apiname).getDescribe().getPickListValues();
        
        if(nullRequired == true){
           // optionlist.add('--None--');
           optionlist.add(defaultValue);
        }
        
        for (Schema.PicklistEntry pv : picklistValues) {
            optionlist.add(pv.getValue());
        }
        return optionlist;
    }
}