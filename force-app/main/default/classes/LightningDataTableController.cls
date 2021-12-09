public class LightningDataTableController {
    /*
	Method Name	: getAccRecords
	Purpose		: To get the wrapper of Columns and Headers
	*/
    @AuraEnabled
    public static DataTableResponse getRecords(String strObjectName, String strFieldSetName, String numberOfRecords){                
       	//Get the fields from FieldSet
        Schema.SObjectType SObjectTypeObj = Schema.getGlobalDescribe().get(String.escapeSingleQuotes(strObjectName));
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();            
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(String.escapeSingleQuotes(strFieldSetName));
        
        //To hold the table hearders 
        List<DataTableColumns> lstDataColumns = new List<DataTableColumns>();
        
        //Field to be queried - fetched from fieldset
        List<String> lstFieldsToQuery = new List<String>();
        
        //Field to be queried - fetched from fieldset
        Map<String, String> lstFieldsToQueryMap = new Map<String, String>();
        
        //The final wrapper response to return to component
        DataTableResponse response = new DataTableResponse();
        
        for( Schema.FieldSetMember eachFieldSetMember : fieldSetObj.getFields() ){
            String dataType = String.valueOf(eachFieldSetMember.getType()).toLowerCase();
            //This way we can set the type of a column
            //We do not get the exact type from schema object which matches to lightning:datatable component structure
            if(dataType == 'datetime'){
                dataType = 'date';
            }
            //Create a wrapper instance and store label, fieldname and type.
            DataTableColumns datacolumns = new DataTableColumns( String.valueOf(eachFieldSetMember.getLabel()) , 
                                                                String.valueOf(eachFieldSetMember.getFieldPath()), 
                                                                String.valueOf(eachFieldSetMember.getType()).toLowerCase(),true,true);
			lstDataColumns.add(datacolumns);
            lstFieldsToQuery.add(String.valueOf(eachFieldSetMember.getFieldPath()));
            lstFieldsToQueryMap.put(String.valueOf(eachFieldSetMember.getFieldPath()),String.valueOf(eachFieldSetMember.getType()));
        }
        List<String> setFields = new List<String>();
        for(String lfqp : lstFieldsToQueryMap.keySet()) {                           

            if(lstFieldsToQueryMap.get(lfqp) == 'reference' && (lfqp.contains('__c'))) {                                         	
            	lfqp = lfqp.removeEnd('__c')+ '__r.Name';
                setFields.add(lfqp); 
            }                     
            else if(lstFieldsToQueryMap.get(lfqp) == 'reference'){ 
                lfqp = lfqp.removeEnd('Id')+ '.Name';
                setFields.add(lfqp); 
            } else{
                setFields.add(lfqp);
            } 
        }
        List<String> setfieldNames = new List<String>();
        for(integer c=0, clang=lstDataColumns.size(); c<clang; c++){                                
                if(lstDataColumns[c].type == 'reference') {                     
                    if(lstDataColumns[c].fieldName.indexOf('__c') == -1) {                     	
                        setfieldNames.add(lstDataColumns[c].fieldName.removeEnd('Id') + '.Name'); 
                        lstDataColumns[c].fieldName = lstDataColumns[c].fieldName.removeEnd('Id') + 'Name'; 
                        lstDataColumns[c].label = lstDataColumns[c].label.removeEnd('ID') + ' Name';
                        lstDataColumns[c].type = 'url';
                        lstDataColumns[c].editable = false;
                    }                     
                    else {                     	
                        setfieldNames.add(lstDataColumns[c].fieldName.removeEnd('__c') + '__r.Name');
                        lstDataColumns[c].type = 'url';
                        lstDataColumns[c].editable = false;
                    }                 
                }else{
                    if(lstDataColumns[c].fieldName == 'Name'){
                        setfieldNames.add(lstDataColumns[c].fieldName);
                        lstDataColumns[c].fieldName = 'link'+lstDataColumns[c].fieldName;
                        lstDataColumns[c].type = 'url';	
                        lstDataColumns[c].editable = false;
                    }else{
                    	setfieldNames.add(lstDataColumns[c].fieldName);
                    }
                }                    
        }         
        system.debug('mahesh:'+setfieldNames);
        //Form an SOQL to fetch the data - Set the wrapper instance and return as response
        if(! lstDataColumns.isEmpty()){  
            response.lstDataTableColumns = lstDataColumns;
            String query = 'SELECT ' + String.join(setfieldNames, ',') + ' FROM '+ String.escapeSingleQuotes(strObjectName) + ' LIMIT '+String.escapeSingleQuotes(numberOfRecords);
            System.debug(query);
            response.lstDataTableData = Database.query(query);
            response.lstFieldsToQuery = setFields;
        }
        return response;
    }
    
    //Wrapper class to hold Columns with headers
    public class DataTableColumns {
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled       
        public String fieldName {get;set;}
        @AuraEnabled
        public String type {get;set;}
        @AuraEnabled
        public Boolean sortable {get;set;}
        @AuraEnabled
        public Boolean editable {get;set;}
        
        //Create and set three variables label, fieldname and type as required by the lightning:datatable
        public DataTableColumns(String label, String fieldName, String type, Boolean sortable, Boolean editable){
            this.label = label;
            this.fieldName = fieldName;
            this.type = type;   
            this.sortable = sortable;
            this.editable = editable;
        }
    }
    
    //Wrapper calss to hold response - This response is used in the lightning:datatable component
    public class DataTableResponse {
        @AuraEnabled
        public List<DataTableColumns> lstDataTableColumns {get;set;}
        @AuraEnabled
        public List<sObject> lstDataTableData {get;set;}  
        @AuraEnabled
        public List<String> lstFieldsToQuery {get;set;}  
        
        public DataTableResponse(){
            lstDataTableColumns = new List<DataTableColumns>();
            lstDataTableData = new List<sObject>();
            lstFieldsToQuery = new List<String>();
        }
    }
    
    //get URL  Record
    @AuraEnabled
    public static String getURL(){
        return URL.getSalesforceBaseUrl().getHost();
    }
    
    //Delete Record
    @AuraEnabled
    public static void deleteRecord(sObject record){
        try{
        	Delete record;
        }catch(Exception e){
            //get exception message
            throw new AuraHandledException(e.getMessage());
        }
    }
        
    //update record - Invoke on Inline Edi
    @AuraEnabled
    public static Boolean updateRecord(List<sObject> recordList){
        try {            
            update recordList;  
            return true;                
        }catch(Exception e) {            
            return false;                
        }  
    }
        
   	//user Context UI Theme
    @AuraEnabled
    public static String getUITheme() {
        String theme = UserInfo.getUiThemeDisplayed();
        return theme;
    }
    
    /*@AuraEnabled
    public static DataTableResponse fetchRecords(String searchKeyWord, List<String> lstFieldsToQuery, String strObjectName, Integer numberOfSearchRecord) {
        String searchKey = searchKeyWord + '%';
        List < Account > returnList = new List < Account > ();
        List < Account > lstOfAccount = [select queryField from Account
                                         where Name LIKE: searchKey LIMIT 500];
         //To hold the table hearders 
          System.debug(lstFieldsToQuery);
        List<DataTableColumns> lstDataColumns = new List<DataTableColumns>();
         //The final wrapper response to return to component
        DataTableResponse response = new DataTableResponse();
        String query = 'SELECT ' + String.join(lstFieldsToQuery, ',') + ' FROM ' +strObjectName+ ' WHERE Name LIKE: searchKey LIMIT '+numberOfSearchRecord;
         System.debug(query);
         response.lstDataTableData = Database.query(query);
        return response;
    }*/
}