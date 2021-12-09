public with sharing class LC_CreateCallReportController {
    @auraEnabled 
    public Static Map<String,Object> createRecord(Id recId, String destObjName){
        //MAP for storing default/returnObject value from event record
        Map<String,Object> defVal = new Map<String, Object>();
        Map<String,Object> returnObject = new Map<String, Object>();
        //String for storing source/Destinition fields from metadata
        String srcField = '';
        String destField = '';
        String recTypeId;
        String srcObjName;
        String srcObjQueryFields = '';
   		//get source object API name based on record Id
        srcObjName = recId.getSObjectType().getDescribe().getName();
        //Retriev custom metadata
        RecordCopyPredicate__mdt recordCopyPredicateMetadata = [SELECT DeveloperName, Source_Obj_API_Name__c, Destination_Obj_API_Name__c, FieldMappingDefinition__c, User_Type__c
                                                                FROM RecordCopyPredicate__mdt 
                                                            WHERE Source_Obj_API_Name__c=:srcObjName AND Destination_Obj_API_Name__c=:destObjName];
        //prepare retunObject for return back to client controller
        returnObject.put('entityApiName', recordCopyPredicateMetadata.Destination_Obj_API_Name__c);
        
        //Determine to create Commercial/CIB call report based on logged-in user.
        /*User loggedInUser = UserDetails.getUserDetails(UserInfo.getUserId());
        List<String> userTypeList = recordCopyPredicateMetadata.User_Type__c.split(';');*/
        
        // Util class that gets record Id, developer name from sObject type.Reuse utilityservice
        //Map<String, String> recTypes = UtilityService.getRecordTypes(UtilityService.SObjectName.CALL_REPORT);            
        //set record type for returnig back to client controller
        /*if( recTypes.ContainsKey(loggedInUser.User_Type__c) ){
            recTypeId = recTypes.get(loggedInUser.User_Type__c);
        }*/
        returnObject.put('recordTypeId', recTypeId);
        for(String fieldStr : recordCopyPredicateMetadata.FieldMappingDefinition__c.split(';')){
            srcField = fieldStr.substringBefore(':');
			srcObjQueryFields += srcField+',';
        }
        if(srcObjName == 'Event'){
            //Prepare and Fetch Query for Source Object Record
            String srcObjQuery = 'SELECT '+srcObjQueryFields+'WhatId'+ 
               					 ' FROM '+srcObjName+ 
                				 ' WHERE Id=\''+recId+'\' LIMIT 1';
            Event srcObj = Database.query(srcObjQuery);
            //Retrieve Source/Destinition Fields from Custom Metadata
            for(String fieldStr : recordCopyPredicateMetadata.FieldMappingDefinition__c.split(';')){
                srcField = fieldStr.substringBefore(':');
                destField = fieldStr.substringAfter(':');
                //Prepare MAP for default values
                defVal.put(destField,srcObj.get(srcField));             
            }
            //Retrieve related Opportunity and Account
            /*if(srcObj.WhatId != NULL && ((String)srcObj.WhatId).StartsWith(ConstantsClass.STARTS_WITH_006)){           
                defVal.put('Deal__c',srcObj.WhatId);
                Opportunity oppObj= [SELECT AccountId 
                                     FROM Opportunity 
                                     WHERE Id =:srcObj.WhatId];
                Id accntId = oppObj.AccountId;   
                defVal.put('Client__c',accntId);
            }else if(srcObj.WhatId != NULL && ((String)srcObj.WhatId).StartsWith(ConstantsClass.STARTS_WITH_001)){           
                defVal.put('Client__c',srcObj.WhatId);
            } */ 
        }else if(srcObjName == 'Account'){
            srcObjQueryFields = srcObjQueryFields.removeEnd(',');
            //Prepare and Fetch Query for Source Object Record
            String srcObjQuery = 'SELECT '+srcObjQueryFields+ 
                				 ' FROM '+srcObjName+ 
                				 ' WHERE Id=\''+recId+'\' LIMIT 1';
            Account srcObj = Database.query(srcObjQuery);
            //prepare pre-field values from account to call report
            for(String fieldStr : recordCopyPredicateMetadata.FieldMappingDefinition__c.split(';')){
                srcField = fieldStr.substringBefore(':');
                destField = fieldStr.substringAfter(':'); 
                //check for Name field and re-format to populate in Call Report Name Field
                if(srcField == 'Name'){
                    srcField = srcObj.get(srcField)+' '+Datetime.now().format('MM-dd-yyyy');
                    //put default value from source to destinition field
                    defVal.put(destField,srcField);
                }else{
                    //put default value from source to destinition field
                    defVal.put(destField,srcObj.get(srcField));
                }                        
            }
            //put default value from source to destinition field
            defVal.put('Created_From_Id__c',srcObj.Id);
            defVal.put('Call_Date_Time__c',System.now());  
        }       
        //set default value for returning back to client controller
        returnObject.put('defaultFieldValues', defVal);
        //return object to client controller for creation of call report record
        return returnObject;
    }
}