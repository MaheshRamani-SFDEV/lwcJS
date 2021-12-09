public with sharing class SampleTriggerHelper {
    Public Static Set<Id> accountIds = new Set<Id>();
    //Static variable to control code execution in trigger.
    //private static boolean executedFlag = false;
    public static boolean isTriggerBypassed(){
        //return (Custom_setting__c.getInstance() != null && Custom_setting__c.getInstance().ByPassAccountTrigger__c); //this will be record with field of checkbox and dont mark it as true. 
        return true;    
    }
    Public Static void beforeInsertHelper (List<Account> accountList){
        
    }    
    Public Static void beforeUpdateHelper(Map<Id, Account> newAccountMap, Map<Id, Account> oldAccountMap){
       
    }    
    Public Static void beforeDeleteHelper (Map<Id, Account> oldAccountMap){
       
    }   
    Public Static Void afterInsertHelper(Map<Id,Account> newSObjectMap){
        
    }
    Public Static Void afterUpdateHelper(Map<Id,Account> newSObjectMap, Map<id,Account> oldSObjectMap){
        // PreventSameUserFromBeingAddedMoreThanOnce(newSObjectMap.values());
         
    }    
    Public Static Void afterDeleteHelper(Map<Id,Account> oldSObjectMap){

    }    
    Public Static Void afterUndeleteHelper(Map<Id,Account> newSObjectMap){
       
        
    } 
}