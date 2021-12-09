public with sharing class BigObjectUtilityController {
   //Wrapper class to hold Columns with headers
   public class DataTableColumns {
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled       
        public String fieldName {get;set;}
        @AuraEnabled
        public String type {get;set;}      
        //Create and set three variables label, fieldname and type as required by the lightning:datatable
        public DataTableColumns(String label, String fieldName, String type ){
            this.label = label;
            this.fieldName = fieldName;
            this.type = type;               
        }
    }
  //Method to get objects in the select list
  //************************************************************************************//
    @AuraEnabled(cacheable=true)
    public static List<wrapObjects> getOptions() 
    {
        List<wrapObjects> objLst = new List<wrapObjects>();
        String objName='';
        String objLabel='';
        for( Schema.SObjectType o: Schema.getGlobalDescribe().values())
        {
            objName= o.getDescribe().getName();
            objLabel = o.getDescribe().getLabel();
            if(objName.contains('__b'))
            {
         	    objLst.add(new wrapObjects(objLabel,objName));
            }
        }
        objLst.sort();       
        return objLst;
    }
   //Method to get columns for the selected object in the dual list box
  //************************************************************************************//
    @AuraEnabled(cacheable=true)
    public static List<wrapObjects> getColumns(String objvalue) 
    {
        List<wrapObjects> fieldLst = new List<wrapObjects>();
        String fname ='';
        String flabel ='';
        SObjectType objType = Schema.getGlobalDescribe().get(objvalue);
        Map<String,Schema.SObjectField> allfields = objType.getDescribe().fields.getMap();
        for(Schema.SObjectField eachFieldMember:allfields.values())
        {
            schema.describefieldresult fieldRes = eachFieldMember.getDescribe();
            fname =  String.valueOf(fieldRes.getName());         
            if( fname.equalsIgnoreCase('id') ){
                continue;
            }
            flabel  = String.valueOf(fieldRes.getLabel());            
            //Create a wrapper instance and store label, fieldname.            
            fieldLst.add(new wrapObjects(flabel,fname)); 	
        }
        fieldLst.sort();       
        return fieldLst;
    }
    //*********************************************************************************//    
    //Wrapper class to add objects to combo box
    public class wrapObjects implements Comparable {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        public wrapObjects(String objlabel,String apiname){
            this.label = objlabel;
            this.value = apiname;
        }        
        public Integer compareTo(Object compareTo) {
        wrapObjects compareToEmp = (wrapObjects)compareTo;
        if (value == compareToEmp.value) return 0;
        if (value > compareToEmp.value) return 1;
        return -1;        
        }        
    } 
    //************************************************************************************//    
    @AuraEnabled(cacheable=true)
    public static DataTableResponse getBigOData(String objvalue, String whereClause, List<String> selColumns) 
    {
        //The final wrapper response to return to component
        DataTableResponse response = new DataTableResponse();
        if(selColumns.isEmpty() || whereClause =='')
        {
            return response;
        }      
        integer numberOfColForDisplay=4;
        integer countOfColumns=0;
        List<String> keyNames= new List<String>(); //used for excel headers for export functionality

        SObjectType objType = Schema.getGlobalDescribe().get(objvalue);
        Map<String,Schema.SObjectField> allfields = objType.getDescribe().fields.getMap();
     
        //To hold the table headers 
        List<DataTableColumns> lstDataColumns = new List<DataTableColumns>();
        
        //Field to be queried - fetched from fieldset
        //List<String> lstFieldsToQuery = new List<String>();
        String fieldNames = '';
        for(Schema.SObjectField eachFieldMember:allfields.values())
        {
            schema.describefieldresult fieldRes = eachFieldMember.getDescribe();
                      
            String fType = String.valueOf(fieldRes.getType()).toLowerCase();
            //This way we can set the type of a column
            //We do not get the exact type from schema object which matches to lightning:datatable component structure
            if(fType == 'datetime'){
                fType = 'datetime';
            }
            if(fType == 'id'){
                fType = 'text';
            }
             if(fType == 'reference'){
                fType = 'text';
            }
           if(fType == 'double'){
                fType = 'number';
            }
            String flabel  = String.valueOf(fieldRes.getLabel());
            String fname =  String.valueOf(fieldRes.getName());
           
            //ToDO- we can restrict number of columns shown on the datatable here
            //if( fname.equalsIgnoreCase('id') || fname.equalsIgnoreCase('Createdbyid') || fname.equalsIgnoreCase('systemmodstamp') )
            if( selColumns.isEmpty() || selColumns.contains(fname) )
             {
                 DataTableColumns datacolumns = new DataTableColumns(flabel,fname,fType);
            //Restrict the number of columns if the columns are more than 5(excluding the above standard fields )
           // countOfColumns++;
           /*     if(countOfColumns<=numberOfColForDisplay)
                {*/
                    lstDataColumns.add(datacolumns);
                    fieldNames = fieldNames + fname + ',';
                    keyNames.add(fname);
             }
             else 
             {
                 continue;
            //Create a wrapper instance and store label, fieldname and type.
           
                //}
           
            }
            
        }
         fieldNames = fieldNames.removeEnd(',');
        
        if(! lstDataColumns.isEmpty()){      
            //DataTableColumns datacolumns = new DataTableColumns('View','view','button-icon'); 
          //  lstDataColumns.add(datacolumns);
            response.lstDataTableColumns = lstDataColumns;
            String query='';
            if(whereClause!='' && whereClause!=null)
            {
             query = 'Select ' + fieldNames + ' FROM '+ objvalue + ' WHERE ' + whereClause;
            }
            else{ 
                 query = 'Select ' + fieldNames + ' FROM '+ objvalue;
            }
            List<sobject> dataLst = Database.query(query);
            response.columnNames = keyNames;
            response.lstDataTableData = dataLst;
        
        }
        return response;
    }   
    //Wrapper class to hold response - This response is used in the lightning:datatable component
     public class DataTableResponse {
       @AuraEnabled
        public List<DataTableColumns> lstDataTableColumns {get;set;}
        @AuraEnabled
        public List<sObject> lstDataTableData {get;set;}                
        @AuraEnabled
        public List<String> columnNames {get;set;}

        public DataTableResponse(){
            lstDataTableColumns = new List<DataTableColumns>();
            lstDataTableData = new List<sObject>();
            columnNames = new List<String>();
        }
    } 
    //method to populate index fields
    @AuraEnabled(cacheable=true)
    public static List<wrapFields> getIndexFieldOptions(String objvalue) 
    {
        List<wrapFields> objLst = new List<wrapFields>();
        String objName='';
        String objLabel='';
        String objdataType='';
        List<FieldDefinition> indexedAccountFields = [SELECT DataType,MasterLabel,QualifiedApiName FROM FieldDefinition WHERE IsApiFilterable = true 
                                                        AND EntityDefinition.QualifiedApiName =: objvalue];

        for(integer count=0;count<indexedAccountFields.size();count++)
        {
         objLabel= indexedAccountFields[count].MasterLabel;
         objName =indexedAccountFields[count].QualifiedApiName;
         objdataType = indexedAccountFields[count].DataType; 
         //map this field with date , datetime, number, text
         if(objdataType.equalsIgnoreCase('Date/Time')){
             objdataType='datetime';
         }         
         else if(objdataType.contains('Lookup')  || objdataType.contains('text') )
         {
             objdataType='text';
         }
         else if(objdataType.contains('double')){
             objdataType='number';
         }

         objLst.add(new wrapFields(objLabel,objName, objdataType));
        }   
        
        objLst.sort();       
        return objLst;
    }
    //Wrapper class to add options to filter conditions
    public class wrapFields implements Comparable {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        @AuraEnabled public String objDT;
        public wrapFields(String objlabel,String apiname, String objDataType){
            this.label = objlabel;
            this.value = apiname;
            this.objDT = objDataType;
        }        
        public Integer compareTo(Object compareTo) {
        wrapFields compareToEmp = (wrapFields)compareTo;
        if (value == compareToEmp.value) return 0;
        if (value > compareToEmp.value) return 1;
        return -1;        
        }        
    }    
}