public class MetaData { 
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
    public static String getMetaData(String fieldIds){
        String bodyToReturn;
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + fetchUserSessionId()); //Get user Session ID
        req.setHeader('Content-Type', 'application/json');
        String SFdomainUrl=URL.getSalesforceBaseUrl().toExternalForm();
        String query='SELECT RefMetadataComponentId, MetadataComponentName, MetadataComponentType,'+ 
                                              'RefMetadataComponentName '+
                                         'FROM MetadataComponentDependency '+
                                         'WHERE RefMetadataComponentId IN ('+ fieldIds +') '+ 
                                         'AND MetadataComponentType <> \'Report\' '+ 
                                         'AND MetadataComponentType <> \'ReportType\'';
        req.setEndpoint(SFdomainUrl+'/services/data/v47.0/tooling/query/?q='+EncodingUtil.urlEncode(query, 'UTF-8'));
        req.setMethod('GET');
        Http h = new Http();
        if(Test.IsRunningTest()){
            bodyToReturn = '{"size":5,"totalSize":5,"done":true,"queryLocator":null,"entityTypeName":"MetadataComponentDependency","records":[{"attributes":{"type":"MetadataComponentDependency","url":"/services/data/v47.0/tooling/sobjects/MetadataComponentDependency/000000000000000AAA"},"Id":"000000000000000AAA","RefMetadataComponentId":"00N80000004ze2MEAQ","MetadataComponentName":"Duplicate_ID","MetadataComponentType":"CustomField","RefMetadataComponentName":"Account_ID_Case_Insensitive"},{"attributes":{"type":"MetadataComponentDependency","url":"/services/data/v47.0/tooling/sobjects/MetadataComponentDependency/000000000000000AAA"},"Id":"000000000000000AAA","RefMetadataComponentId":"00N80000004ze2MEAQ","MetadataComponentName":"View AML/RAF Data","MetadataComponentType":"WebLink","RefMetadataComponentName":"Account_ID_Case_Insensitive"},{"attributes":{"type":"MetadataComponentDependency","url":"/services/data/v47.0/tooling/sobjects/MetadataComponentDependency/000000000000000AAA"},"Id":"000000000000000AAA","RefMetadataComponentId":"00N80000004ze2MEAQ","MetadataComponentName":"Update Account Status","MetadataComponentType":"WebLink","RefMetadataComponentName":"Account_ID_Case_Insensitive"},{"attributes":{"type":"MetadataComponentDependency","url":"/services/data/v47.0/tooling/sobjects/MetadataComponentDependency/000000000000000AAA"},"Id":"000000000000000AAA","RefMetadataComponentId":"00N80000004ze2MEAQ","MetadataComponentName":"UniqueRelationship","MetadataComponentType":"WorkflowFieldUpdate","RefMetadataComponentName":"Account_ID_Case_Insensitive"},{"attributes":{"type":"MetadataComponentDependency","url":"/services/data/v47.0/tooling/sobjects/MetadataComponentDependency/000000000000000AAA"},"Id":"000000000000000AAA","RefMetadataComponentId":"00N80000004ze2MEAQ","MetadataComponentName":"uniquecontrollingperson","MetadataComponentType":"WorkflowFieldUpdate","RefMetadataComponentName":"Account_ID_Case_Insensitive"}]}';
        } else {
            HttpResponse response = h.send(req);
            bodyToReturn = response.getBody();
        }
        return bodyToReturn;
    }
    
}