public class RecordTypeSelectorController {
  
    @AuraEnabled
    public static List<RecordType> getListOfRecordType(){
        String query = 'SELECT Id,Name FROM RecordType WHERE SobjectType =\''+'Opportunity'+'\' ';
        List<RecordType> rtNames = new List<RecordType>();
        Schema.SObjectType  objType = Opportunity.SObjectType;      
        for(RecordTypeInfo rt : objType.getDescribe().getRecordTypeInfos()){
            System.debug('rt.getName()'+rt.getName());
            rtNames.add(new RecordType(Id = rt.getRecordTypeId(),Name = rt.getName()));
            System.debug('rtNames'+rtNames);
        }  
        return rtNames;  
    }
}