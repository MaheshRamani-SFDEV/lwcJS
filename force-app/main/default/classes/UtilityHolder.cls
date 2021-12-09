public class UtilityHolder{

    public static Boolean loanStopRecursion = false;
    // declare the variables
    static List<Error_Log__c> lstErrorLog = new List<Error_Log__c>();
    static Error_Log__c objErrorLog;
    
    /*
    * method name - errorMethod
    * arguments   - String objectName, String className, String methodName, String sSeverity, String sErrorMsg
    * return type - void
    * description - This is the generic method that can create List of ERROR records in the Error Log
    *               when an error has occurred while making any DML operation.
    */
    public static void errorMethod(String objectName, String className, String methodName, String sSeverity, Map<String,String> failedIds){
        // clear the list
        lstErrorLog.clear();
            String failedRecIds='';
            String failedErrorMsg='';
        Boolean oneTimeDML = true;
        // ++ if the issue is of type Error
            for(String recId :FailedIds.keyset()){
                objErrorLog = new Error_Log__c();
                // map the values to the field and put that in the list that will be inserted later
                objErrorLog.Object_Name__c = objectName;
                objErrorLog.Apex_Class_Trigger__c = className;
                objErrorLog.Method_Name__c = methodName;
                //objErrorLog.Description__c = sErrorMsg.length()>32768 ? sErrorMsg.substring(4,32768): sErrorMsg;
                objErrorLog.Severity__c = sSeverity;
                objErrorLog.type__c = 'Error';
            	objErrorLog.FailedRecordIds__c=recId;
            	objErrorLog.DMLMessage__c=failedIds.get(recId);
            	lstErrorLog.add(objErrorLog);
            }
        	system.debug('###lstErrorLog--> '+lstErrorLog);
                        
        // check if the size of lstErrorLog is greater than zero. This will happen
        // if a record has failed while causing the DML operation.
        if(null != lstErrorLog && lstErrorLog.size()>0 && oneTimeDML){
            insert lstErrorLog;
            oneTimeDML = false;
        }
    }
    
    /*
    * method name - errorMethod
    * arguments   - String objectName, String className, String methodName, String sSeverity, String sErrorMsg
    * return type - void
    * description - This is the generic method that can create ERROR records in the Error Log
    *               when an error has occurred while making any DML operation.
    */
    public static void errorMethod(String objectName, String className, String methodName, String sSeverity, String sErrorMsg, Integer lineNo){
        // clear the list
        lstErrorLog.clear();
        // ++ if the issue is of type Error
        if(null != sErrorMsg && sErrorMsg != ''){
            objErrorLog = new Error_Log__c();
            // map the values to the field and put that in the list that will be inserted later
            objErrorLog.Object_Name__c = objectName;
            objErrorLog.Apex_Class_Trigger__c = className;
            objErrorLog.Method_Name__c = methodName;
            objErrorLog.Description__c = sErrorMsg.length()>32768 ? sErrorMsg.substring(4,32768): sErrorMsg;
            objErrorLog.Severity__c = sSeverity;
            objErrorLog.type__c = 'Error';
            objErrorLog.Line_Number__c = lineNo; //Added By: Shakti Mehtani - 08/17/2015
            lstErrorLog.add(objErrorLog);
                
        }
        // check if the size of lstErrorLog is greater than zero. This will happen
        // if a record has failed while causing the DML operation.
        if(null != lstErrorLog && lstErrorLog.size()>0){
            insert lstErrorLog;
        }
    }
    
    /*
    * method name - errorMethod
    * arguments   - String objectName, String className, String methodName, String sSeverity, Exception e
    * return type - String sMessage
    * description - This is the generic method that can create EXCEPTION records in the Error Log
    *               when an esxception has occurred while making any operation.
    */    
    public static String errorMethod(String objectName, String className, String methodName, String sSeverity, Exception ex){
        //Map<String, Error_Messages_Setting__c> errorMessageSettings = Error_Messages_Setting__c.getAll();
        // clear the list
        lstErrorLog.clear();
        //Added by Shashank Tiwari on August 24, 2015 for removal of 'System.' from Exception.getTypeName() return
        System.debug('typeName -----'+ex.getTypeName());
        String typeName = ex.getTypeName().remove('System.');
        //change by Shashank ends here
        // get the message for the occured Exception 
        System.debug('JException->'+ex + ' - ' + ex.getStackTraceString());
        String sMessage = ex.getMessage();//errorMessageSettings.get(typeName).value__c;
        // ++ if the issue is of type Exception
        if(null != ex){
            objErrorLog = new Error_Log__c();
            // map the values to the field and put that in the list that will be inserted later
            objErrorLog.Object_Name__c = objectName;
            objErrorLog.Apex_Class_Trigger__c = className;
            objErrorLog.Method_Name__c = methodName;
            //objErrorLog.Description__c = ex.getStackTraceString();
            objErrorLog.Description__c = 'Error Message --> ' + ex.getMessage() + ' | Stack Trace --> ' + ex.getStackTraceString(); //Modified By: Shakti Mehtani 09/28/2015
            objErrorLog.Severity__c = sSeverity;
            objErrorLog.type__c = 'Exception';
            objErrorLog.Line_Number__c = ex.getLineNumber(); //Added By: Shakti Mehtani - 08/17/2015
            lstErrorLog.add(objErrorLog);
        }
        //check if the size of lstErrorLog is greater than zero. This will happen
        // if a record has failed while causing the DML operation
        if(null != lstErrorLog && lstErrorLog.size()>0){
            insert lstErrorLog;
        }


        //return sMessage;
        return string.IsBlank(sMessage) ? '' : sMessage;
    }
    
    /**
     * Return's the Sobject api name based on the record id prefix
     **/
    public static String getSObjectType(String recordId){
        if(null == recordId || recordId.length() < 3) return null;      
        return getSobjectPrefixAndName().get(recordId.subString(0,3)).getName();    
    }

    public static boolean compareSobjectType(SObject compare, String checkType){
        try{
            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(checkType);
            if(targetType == null){
                return false;
            }else if(compare.getSObjectType() == targetType){
                return true;
            }else{
                return false;
            }
        }catch(Exception e){
            //handle exception
            return false;
        }
       // return false;
    }
    
    /**
     * Return's a map with the key being the prefix and the value being the Sobject Name
     **/
    public static Map<String, Schema.DescribeSObjectResult> getSobjectPrefixAndName(){
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Map<String, Schema.DescribeSObjectResult> keyPrefixMap = new Map<String, Schema.DescribeSObjectResult>();
        for(String sObj : gd.keySet()){
            Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();  
            keyPrefixMap.put(r.getKeyPrefix(), r);
        }  
        return keyPrefixMap;
    }
    
    /**
     * Creates a new Instance of the String API Name of that Sobject
     **/
    public static sObject createObject(String typeName){
        return createObject(typeName, null); 
    }
    public static sObject createObject(String typeName, String id){
        if (typeName == null) {
            return null;
        }
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(typeName);
        if (targetType == null) {
            return null;
        }    
        if(null != id)
            return targetType.newSObject(Id = id);
        else 
            return targetType.newSObject(); 
    }
    
    /**
     * Validates if a record has a unique value
     **/  
    public static void validateFieldUniqueness(DescribeFieldResult sObjectField, List<Sobject> records){ 
        validateFieldUniqueness(sObjectField, records, null);
    }
    public static void validateFieldUniqueness(DescribeFieldResult sObjectField, List<Sobject> records, String customErrorMessage){
        if(null == records || 0 == records.size()) return;
        if(null == sObjectField) return;
        
        String sObjectApiFieldName = sObjectField.getName();
        String sObjectFieldLabel = sObjectField.getLabel();
        String errorMessage = null != customErrorMessage ? customErrorMessage : sObjectFieldLabel + ' is not unique.';
        
        String sObjectType = records[0].getSobjectType().getDescribe().getName();
        Set<String> recordValues = new Set<String>();
        Map<String, Sobject> recordMap = new Map<String, Sobject>();
        for(Sobject record :records){
            String fieldValue = (String)record.get(sObjectApiFieldName);
            if(null == fieldValue || 'null' == fieldValue) continue;
            if(recordValues.contains(fieldValue)){
                record.addError(errorMessage);
            }else{
                recordValues.add(fieldValue);
                recordMap.put(fieldValue, record);
            }
        }
        
        for(Sobject record :Database.query('select id,' + sObjectApiFieldName + ' from ' + sObjectType + ' where ' + sObjectApiFieldName + ' in :recordValues')){           
            if(recordMap.keySet().contains((String)record.get(sObjectApiFieldName))){
                String fieldValue = (String)record.get(sObjectApiFieldName);
                if(null == fieldValue || 'null' == fieldValue) continue;
                Sobject tempRecord = recordMap.get(fieldValue);
                if(tempRecord.Id != record.Id){
                    tempRecord.addError(errorMessage);
                }
            }
        }
    }
    
    public static String parseCalloutFault(String exceptionMessage){ return parseCalloutFault(exceptionMessage, null, null); }
    public static String parseCalloutFault(Exception e){ return parseCalloutFault(e, 'soap fault:', 'faultcode='); }
    public static String parseCalloutFault(Exception e, String firstFilter, String secondFilter){ return parseCalloutFault(e.getMessage(), 'soap fault:', 'faultcode='); }
    public static String parseCalloutFault(String exceptionMessage, String firstFilter, String secondFilter){
        system.debug('Exception Message: ' + exceptionMessage);
        if(null != exceptionMessage && exceptionMessage.containsIgnoreCase(firstFilter) && exceptionMessage.substring(exceptionMessage.indexOfIgnoreCase(firstFilter) + firstFilter.length()).containsIgnoreCase(secondFilter)){
            exceptionMessage = exceptionMessage.substring(exceptionMessage.indexOfIgnoreCase(firstFilter) + firstFilter.length(), exceptionMessage.indexOfIgnoreCase(secondFilter));
        }
        return exceptionMessage;
    }

    //Method to return boolean value of a field
    public static Boolean getBoolVal(Object val){
    if(val == NULL) return false;
    return Boolean.valueOf(String.Valueof(val));    
    }
    
    /**
    	Common method to perform DML on Entity, invoked from this class.
    */
    public static string parseSaveResultsErrors(Database.SaveResult[] srList ){
    	// Iterate through each returned result
		string errorMsg = '';
		for (Database.SaveResult sr : srList) {
		    if (!sr.isSuccess()) {
		        for(Database.Error err : sr.getErrors()) {
		        	errorMsg +=  '\n' + err.getStatusCode() + ': ' + err.getMessage() + ' Field Causing this error: ' + err.getFields();
		        }
		    }
		}
		return errorMsg;
    }
    
    /**
    	Common method to perform DML on Entity, invoked from this class.
    */
    public static string parseUpsertResultsErrors(Database.UpsertResult[] urList ){
    	// Iterate through each returned result
		string errorMsg = '';
		for (Database.UpsertResult ur : urList) {
		    if (!ur.isSuccess()) {
		        for(Database.Error err : ur.getErrors()) {
		        	errorMsg +=  '\n' + err.getStatusCode() + ': ' + err.getMessage() + ' Field Causing this error: ' + err.getFields();
		        }
		    }
		}
		return errorMsg;
    }
    
    /**
    	Common method to perform DML on Entity, invoked from this class.
    */
    public static string parseDeleteResultsErrors(Database.DeleteResult[] drList ){
    	// Iterate through each returned result
		string errorMsg = '';
		for (Database.DeleteResult dr : drList) {
		    if (!dr.isSuccess()) {
		        for(Database.Error err : dr.getErrors()) {
		        	errorMsg +=  '\n' + err.getStatusCode() + ': ' + err.getMessage() + ' Field Causing this error: ' + err.getFields();
		        }
		    }
		}
		return errorMsg;
    }
    

    /*
    * method name - errorMethod
    * arguments   - String objectName, String className, String methodName, String type, Database.SaveResult[] saveResults
    * return type - void
    * description - This is the generic method that can create EXCEPTION records in the Error Log
    *               using the save results.
    */
    public static void errorMethod(String objectName, String className, String methodName, 
                                                 String type, Database.SaveResult[] saveResults){
        List<Error_Log__c> lstErrorLog = new List<Error_Log__c>();
            Error_Log__c objErrorLog;
            for (Database.SaveResult sr : saveResults) {
                if (sr.isSuccess()) {
                    System.debug('Successfully Saved' + sr.getId());
                }
                else {
                    for(Database.Error err : sr.getErrors()) {
                        objErrorLog = new Error_Log__c();
                        objErrorLog.Object_Name__c = objectName;
                        objErrorLog.Apex_Class_Trigger__c = className;
                        objErrorLog.Method_Name__c = methodName;
                        objErrorLog.Description__c = String.join(err.getFields(),'&&');
                        objErrorLog.Severity__c = String.valueOf(err.getStatusCode());
                        objErrorLog.type__c = type;
                        objErrorLog.DMLMessage__c=err.getMessage();
                        lstErrorLog.add(objErrorLog);
                    }
                }
            }
            database.insert(lstErrorLog);
    }


    /*
    * method name - errorMethod
    * arguments   - String objectName, String className, String methodName, String type, Messaging.SendEmailResult[] sendResults
    * return type - void
    * description - This is the generic method that can create EXCEPTION records in the Error Log
    *               using the save results.
    */
    public static void errorMethod(String objectName, String className, String methodName, 
                                                 String type, Messaging.SendEmailResult[] sendResults){
        List<Error_Log__c> lstErrorLog = new List<Error_Log__c>();
            Error_Log__c objErrorLog;
            for (Messaging.SendEmailResult sr : sendResults) {
                if (sr.isSuccess()) {
                    system.debug('##Email Result '+sr);
                }
                else {
                    for(Messaging.SendEmailError err : sr.getErrors()) {
                        objErrorLog = new Error_Log__c();
                        objErrorLog.Object_Name__c = objectName;
                        objErrorLog.Apex_Class_Trigger__c = className;
                        objErrorLog.Method_Name__c = methodName;
                        //objErrorLog.Description__c = String.join(err.getFields(),'&&');
                        //objErrorLog.Severity__c = String.valueOf(err.getStatusCode());
                        objErrorLog.type__c = type;
                        objErrorLog.DMLMessage__c=err.getMessage();
                        lstErrorLog.add(objErrorLog);
                    }
                }
            }
            database.insert(lstErrorLog);
    }
}