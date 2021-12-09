public class ExceptionUtility {
    public static Boolean isrecursion = false;
    public static List<Error_Log__c> lstErrorLog = new List<Error_Log__c>();
    public static Error_Log__c objErrorLog;
    
    public static void errorMethod(String objectName, String className, String methodName, String sSeverity, String sErrorMsg, Integer lineno){
        lstErrorLog.clear();
        if(null != sErrorMsg && sErrorMsg != ''){
            objErrorLog = new Error_Log__c();
            objErrorLog.Object_Name__c = objectName;
            objErrorLog.Apex_Class_Trigger__c = className;
            objErrorLog.Method_Name__c = methodName;
            objErrorLog.Description__c = sErrorMsg.length()>32768? sErrorMsg.subString(4,32768): sErrorMsg;
            objErrorLog.Severity__c = sSeverity;
            objErrorLog.Type__c = 'Error';
            objErrorLog.Line_Number__c = lineno;
            lstErrorLog.add(objErrorLog);
        }
        if(null != lstErrorLog && lstErrorLog.size() > 0){
            insert(lstErrorLog);
        }        
    } 
    public static String errorMethod(String objectName, String className, String methodName, String sSeverity, Exception ex){
        //Map<String, Error_Message_Setting__c> errorMessageSetting = Error_Message_Setting__c.getAll();
        lstErrorLog.clear();
        String typeName = ex.getTypeName().remove('System.');
        String sMessage = ex.getMessage();
        if(null != ex){
            objErrorLog = new Error_Log__c();
            objErrorLog.Object_Name__c = objectName;
            objErrorLog.Apex_Class_Trigger__c = className;
            objErrorLog.Method_Name__c = methodName;
            objErrorLog.Description__c = 'Error Message ----> ' + ex.getMessage() + ' |Stack Trace ' + ex.getStackTraceString();
            objErrorLog.Severity__c = sSeverity;
            objErrorLog.Type__c = 'Error';
            lstErrorLog.add(objErrorLog);
        }
        if(null != lstErrorLog && lstErrorLog.size() > 0){
            insert(lstErrorLog);
        } 
        return string.IsBlank(sMessage) ? '' : sMessage; 
    } 
    public static void errorMethod(String objectName, String className, String methodName, String sSeverity, Map<String, String> FailedIds){
        //Map<String, Error_Message_Setting__c> errorMessageSetting = Error_Message_Setting__c.getAll();
        lstErrorLog.clear();
        String failedRecIds = '';
        String failedErrorMsg = '';
        Boolean OneTimeDML = True;
        for(String recId : FailedIds.keySet()){
            objErrorLog = new Error_Log__c();
            objErrorLog.Object_Name__c = objectName;
            objErrorLog.Apex_Class_Trigger__c = className;
            objErrorLog.Method_Name__c = methodName;
            objErrorLog.FailedRecordIds__c = recId;
            objErrorLog.Severity__c = sSeverity;
            objErrorLog.Type__c = 'Error';
            objErrorLog.DMLMessage__c = FailedIds.get(recId);
            lstErrorLog.add(objErrorLog);
        }
        if(null != lstErrorLog && lstErrorLog.size() > 0 && OneTimeDML){
            insert(lstErrorLog);
            OneTimeDML = false;
        } 
    } 
    
    public static String checkSaveResultForError(Database.SaveResult[] srList){
        string errorMsg = '';
        for(Database.SaveResult sr : srList){
            if(!sr.isSuccess()){
                for(Database.Error err : sr.getErrors()){
                    errorMsg = '/n' + err.getStatusCode() + ': ' + err.getMessage() + ' Fields Causing This Error ' + err.getFields();
                }
            }           
        }
        return errorMsg;
    }
}