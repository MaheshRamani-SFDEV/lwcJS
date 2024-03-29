/* Name: ToolingController
* Description: This Apex class makes callout to Salesforce Tooling Api and get the metadata information about the objects.
* Created By: Mahesh Ramani
*/
public class FindMetadataController {
    
    @AuraEnabled
    public static string GetMetaData(string type){
        
        HttpRequest req = new HttpRequest();
        String session_id;
        if(!test.isRunningTest()){
            session_id = UtilsClass.getSessionIdFromVFPage(Page.SessionIdPage);
        }
        system.debug('Session ID: ' +session_id);
        req.setHeader('Authorization', 'Bearer ' + session_id);
        string domainUrl=URL.getSalesforceBaseUrl().toExternalForm();
        string endpoint='';
        if(type=='ApexClass & ApexTrigger'){
            endpoint='select+id,ApexClassOrTrigger.Name,NumLinesCovered,NumLinesUncovered,Coverage+from+ApexCodeCoverageAggregate';
        }
        else if(type=='ValidationRule'){
            endpoint='Select+id,ErrorDisplayField,createdDate,ValidationName+from+ValidationRule';
        }
        else if(type=='WorkflowRule'){
            endpoint='Select+id,Name+from+WorkflowRule';
        }
        else if(type=='VisualforcePages'){
            endpoint='Select+id,Name,Description,ControllerType,ApiVersion+from+ApexPage';
        }else if(type=='Static Resource'){
            endpoint='select+id,Name,ContentType+from+StaticResource';
        }else if(type=='Email Template'){
            endpoint='select+id,Name,UIType+from+EmailTemplate';
        }else if(type=='Documents'){
            endpoint='select+id,Name,Type,Url+from+Document';
        }else if(type=='Visualforce Component'){
            endpoint='select+id,name+from+ApexComponent';
        }
        req.setEndpoint(domainUrl+'/services/data/v42.0/tooling/query/?q='+endpoint);
        req.setMethod('GET');
        Http h = new Http();
        try{
            HttpResponse response = h.send(req);
            system.debug(response.getBody()); 
            return response.getBody();
        }
        catch(Exception e){
            string exceptionString=e.getMessage();
            system.debug('Exception: '+exceptionString);
            return exceptionString;
        }
        
    } 
}