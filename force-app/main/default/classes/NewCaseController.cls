public with sharing class NewCaseController {
    public static Map<Id, String> recordtypemap {get;set;}    
    
    @AuraEnabled        
    public static String fetchRecordTypeName(Id recordTypeId){
        List<Schema.RecordTypeInfo> recordtypes = Case.SObjectType.getDescribe().getRecordTypeInfos();    
        recordtypemap = new Map<Id, String>();
        for(RecordTypeInfo rt : recordtypes){
            if(rt.getName() != 'Master' && rt.isAvailable())
                recordtypemap.put(rt.getRecordTypeId(), rt.getName());
        } 
        return recordtypemap.get(recordTypeId);
    }
}