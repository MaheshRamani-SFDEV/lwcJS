/*  * Test class for Class LC_NoteRecordController 
    *
    * @name           LC_NoteRecordController 
    * @author         Mahesh Ramani
    * @since          11/27/2019
    * @version        1
    * @Decsription    M11.2019
* */
public with sharing class LC_NoteRecordController {
    @AuraEnabled
    public static String getURL(){
        return URL.getSalesforceBaseUrl().getHost();
    }
    @AuraEnabled
    public static void createNoteRecord (Note note){
        try{
            if(note != null){
                insert note;
            }
        } catch (DmlException e){
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
    @AuraEnabled
    public static List<Note> getRelatedNotes(String recordId) {
        List<Note> notes = [SELECT Id, Title, Body, CreatedDate, CreatedById, CreatedBy.Name  FROM Note Where ParentId = :recordId Order By CreatedDate desc Limit 1000];
        return notes;
    }
    /*@AuraEnabled
    public static Boolean isNoteEnabledBySchema(Id recordId) {
        Boolean hasNoteEnabled = false;
        Schema.SObjectType sObjName = recordId.getSObjectType();        
        List<Schema.sObjectType> objNotesAllowed = Schema.sObjectType.Note.fields.ParentId.getReferenceTo();        
        return objNotesAllowed.contains(sObjName);        
    }*/
    @AuraEnabled
    public static boolean isNoteEnabled(Id recordId) {
        Boolean hasNoteEnabled = false;
        Schema.SObjectType sObjName = recordId.getSObjectType();
        String subQuery = 'select RecordTypeId  from '+ sObjName+' where id = :recordId Limit 1';
        List<sObject> record = Database.query(subQuery);
        String recordTypeId = String.valueOf(record[0].get('RecordTypeId'));
    	String query = 'SELECT Layout.Name FROM ProfileLayout WHERE ProfileId = \'' + UserInfo.getProfileId() + '\' AND RecordTypeId = \'' + recordTypeId + '\'';
        String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
        String endPoint = baseURL + '/services/data/v47.0/tooling/query?q='+ (query.replace(' ', '+'));
        String method = 'GET';
        //Call to method fetchUserSessionId for getting session Id
        String sessionId = fetchUserSessionId();
        //Call to tooling api for getting record page layout -record type name using record id and object name
        Http h = new Http();
        HttpRequest hr = new HttpRequest();
        hr.setHeader('Authorization', 'Bearer ' + sessionId);
        hr.setTimeout(60000);
        hr.setEndpoint(endPoint);
        hr.setMethod(method);
        HttpResponse response = h.send(hr);
        String body = response.getBody();
        String recordTypeName = body.substringBetween('"Name":"', '"');
        //provide page layout name with object name detail to get details of related list on record page using metadata
        String pageLayoutName = sObjName+'-'+recordTypeName;
        List<Metadata.Metadata> layouts = Metadata.Operations.retrieve(Metadata.MetadataType.Layout, new List<String> {sObjName+'-'+recordTypeName});
        Metadata.Layout layoutMd = (Metadata.Layout) layouts.get(0);        
        for (Metadata.RelatedListItem relList : layoutMd.relatedLists) {            
            if(relList.relatedList == 'RelatedNoteList'){
                hasNoteEnabled = true;
            }
        }
        return hasNoteEnabled;
    }
    public static String fetchUserSessionId(){
        String sessionId = '';
        PageReference reportPage = Page.GetSessionIdVF;
        String vfContent;
        if(Test.IsRunningTest()){
            vfContent = 'Start_Of_Session_Id{!$Api.Session_ID}End_Of_Session_Id';    
        } else {
            vfContent = reportPage.getContent().toString();
        }        
        Integer startP = vfContent.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
            endP = vfContent.indexOf('End_Of_Session_Id');
        sessionId = vfContent.substring(startP, endP);
        return sessionId;
    }
}