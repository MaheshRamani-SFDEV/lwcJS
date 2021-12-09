public class CustomDataTableController {
     
    @AuraEnabled
    public static list<FieldSetMemberWrapperClass > getFieldSetMember(String objName, String fsName){
 
        List<FieldSetMemberWrapperClass> wrapperList = new List<FieldSetMemberWrapperClass>();
        Schema.SObjectType sObj = Schema.getGlobalDescribe().get(objName);
  
        for(Schema.FieldSetMember fieldMember : sObj.getDescribe().fieldSets.getMap().get(fsName).getFields()){
            FieldSetMemberWrapperClass wrapper = new FieldSetMemberWrapperClass();
            wrapper.label = fieldMember.getLabel();
            wrapper.fieldName = fieldMember.getFieldPath();
            wrapper.type = String.valueOf(fieldMember.getType());
            wrapper.editable = true;
            wrapperList.add(wrapper);
        }
        return wrapperList;
    }
    
    @AuraEnabled
    public static list<sObject> getRecords(String objName, String fieldLableList, Integer numberOfRecord){
       
        List<sObject> recList = new list<sObject>();   
       
        list<String> apiName = fieldLableList.split(',');
        String query = 'select id ';
        list<String> apiName2 = new list<String>();
        for(String s : apiName){
            if(s.contains('fieldName')){
                apiName2.add(s.substringAfter(':'));
            }  
        }
        for(String st : apiName2){
            query +=', '+st.replaceAll('\"','');
        }
        query.removeEnd(',');
        query +=' FROM '+ objName + ' LIMIT ' + numberOfRecord;
        System.debug('#### query '+query);
        recList = database.query(query);
        return recList;
    }    
     public class FieldSetMemberWrapperClass{
        @AuraEnabled
        public String label        { get; set; }
        @AuraEnabled
        public String fieldName    { get; set; } 
        @AuraEnabled
        public String type         { get; set; }          
         @AuraEnabled
        public Boolean editable    { get; set; }  
    }
    @AuraEnabled
    public static boolean updateRecords(List<sObject> editedRecList){
        try{
            update editedRecList;
            return true;
        } catch(Exception e){
            return false;
        }
    }
}