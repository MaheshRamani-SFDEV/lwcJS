public class MetadataCSV { 
    @AuraEnabled 
    public static list <Object> fetchMetaData(String fieldIds){
        String restQueryResult = MetaData.getMetaData(fieldIds);
        List<Object> returnMetaList = new List<Object>(); 
        Map<String, Object> mapObject = (Map<String, Object>)Json.deserializeUntyped(restQueryResult);
        returnMetaList.addAll((List<Object>)mapObject.get('records'));
        return returnMetaList;
    }
}