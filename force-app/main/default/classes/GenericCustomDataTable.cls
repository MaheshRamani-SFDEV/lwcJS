public class GenericCustomDataTable{
     
  @AuraEnabled
	public static String getFieldSet(String sObjectName, String fieldSetName) {
        String result = '';

        try{
            SObjectType objToken = Schema.getGlobalDescribe().get(sObjectName);
            Schema.DescribeSObjectResult d = objToken.getDescribe();
            Map<String, Schema.FieldSet> FsMap = d.fieldSets.getMap();
            system.debug('>>>>>>> FsMap >>> ' + FsMap);
            if(FsMap.containsKey(fieldSetName))
                for(Schema.FieldSetMember f : FsMap.get(fieldSetName).getFields()) {
                    if(result != ''){
                        result += ',';
                    }
                    String jsonPart = '{';
                    jsonPart += '"label":"' + f.getLabel() + '",';
                    jsonPart += '"required":"' + (f.getDBRequired() || f.getRequired()) + '",';
                    jsonPart += '"type":"' + (f.getType()) + '",';
                    jsonPart += '"name":"' + f.getFieldPath() + '"';
                    jsonPart += '}';
                    result += jsonPart;
            }
        }
        catch(Exception e){
            result += e.getLineNumber() + ' : ' + e.getMessage();
        }
       return '['+result+']';
    }  
    
   
    @AuraEnabled
    public static List<Broker__c> getRecords(String sObjectName, String fieldLableList, Integer numberOfRecords){        
       List<sObject> lstResult = new List<sObject>();
       List<String> fieldNames = (List<String>) JSON.deserialize(fieldLableList, List<String>.class);
        String query = 'SELECT ' + String.join(fieldNames, ',') + ' FROM ' + sObjectName+ ' LIMIT ' + numberOfRecords;
        System.debug('query: '+query);
        lstResult = Database.query(query);
        System.debug('lstResult: '+lstResult);
        return lstResult;
    }
    /*@AuraEnabled
    public static List<Broker__c> getRecords(String sObjectName, String fieldLableList, Integer numberOfRecords){        
        return [SELECT Email__c,Phone__c,Title__c,Call_Type__c,Name,CurrencyIsoCode,Account__c FROM Broker__c LIMIT 5];
    }*/
}