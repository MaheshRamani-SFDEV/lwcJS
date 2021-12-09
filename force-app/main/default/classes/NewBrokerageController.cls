public class NewBrokerageController {
    public static String returnId;    
    public NewBrokerageController(ApexPages.StandardController sc){        
        returnId = ApexPages.currentPage().getParameters().get('retURL').escapeHtml4();
        returnId = returnId.substring(1);
    }
    
    @AuraEnabled 
    public static user fetchUser(){
       User u = [select Id, Name, Phone, Email from User where id =: userInfo.getUserId()];
        return u;
    }
    @AuraEnabled 
    public static String fetchProfile(){
        User u = [select Profile.Name from User where id =: userInfo.getUserId()];
        String profileName = u.Profile.Name;
        system.debug(profileName);
        return profileName;
    }
    @AuraEnabled        
    public static Account fetchRecord(Id recordId){
        Account oppProdRec = [SELECT Id, Name FROM Account WHERE Id=:recordId];
        return oppProdRec;
    }
    
    /*public static PageReference redirect(){
        Account oppProd  = fetchRecord((Id) returnId);
        Broker__c nonStand = new Broker__c();
        PageReference pageRef = new PageReference('/a00/e');
        pageRef.getParameters().put('CF00N7F00000RjSOH', oppProd.Name);
        pageRef.getParameters().put('CF00N7F00000RjSOH_lkid', oppProd.Id);
        pageRef.getParameters().put('CF00N2H0000065QNv', oppProd.Name);
        pageRef.getParameters().put('CF00N2H0000065QNv_lkid', oppProd.Id);
        pageRef.getParameters().put('CF00N34000005cXrv', oppProd.TS_Child_Opportunity__r.Name);
        pageRef.getParameters().put('CF00N34000005cXrv_lkid', oppProd.TS_Child_Opportunity__c);        
        pageRef.getParameters().put('CF00NR0000006lgra', oppProd.TS_Child_Opportunity__r.TSO_Name__r.Name);
        pageRef.getParameters().put('CF00NR0000006lgra_lkid', oppProd.TS_Child_Opportunity__r.TSO_Name__c);
        pageRef.getParameters().put('CF00NR0000006lyYE', oppProd.TS_Child_Opportunity__r.CPO_Name__r.Name);
        pageRef.getParameters().put('CF00NR0000006lyYE_lkid', oppProd.TS_Child_Opportunity__r.CPO_Name__c);
        pageRef.getParameters().put('nooverride', '1');
        pageRef.setRedirect(true);
        return pageRef;
    }*/
    public static PageReference redirect(){
        PageReference pageRef = new PageReference('/a5b/e');
        if(returnId != null){
             //Broker__c nonStand = fetchRecord(returnId);
            //LLC_BI__Opportunity_Product__c oppProd  = fetchRecord(returnId);
            //if(oppProd != null){
                String orgId = UserInfo.getOrganizationId();
                if(orgId != null && orgId.length() > 15){
                    orgId = orgId.substring(0, 15);
                }
                String lkid = '_lkid';
               /* for(RequestFormParameter__mdt param :  [SELECT Field_ID__c, Field_Name__c FROM RequestFormParameter__mdt WHERE Org_ID__c = :orgId]){
                    if(param.Field_Name__c == 'Related_Opportunity_Product__c'){
                        pageRef.getParameters().put(param.Field_ID__c, oppProd.Name);
                        pageRef.getParameters().put(param.Field_ID__c + lkid, oppProd.Id);
                    }else if(param.Field_Name__c == 'Related_Opportunity__c'){
                        pageRef.getParameters().put(param.Field_ID__c, oppProd.TS_Child_Opportunity__r.Name);
                        pageRef.getParameters().put(param.Field_ID__c + lkid, oppProd.TS_Child_Opportunity__c);
                    }else if(param.Field_Name__c == 'Account__c'){
                        pageRef.getParameters().put(param.Field_ID__c, oppProd.Account__r.Name);
                        pageRef.getParameters().put(param.Field_ID__c + lkid, oppProd.Account__c);
                    }else if(param.Field_Name__c == 'TSO__c'){
                        pageRef.getParameters().put(param.Field_ID__c, oppProd.TS_Child_Opportunity__r.TSO_Name__r.Name);
                        pageRef.getParameters().put(param.Field_ID__c + lkid, oppProd.TS_Child_Opportunity__r.TSO_Name__c);
                    }else if(param.Field_Name__c == 'CPO__c'){
                        pageRef.getParameters().put(param.Field_ID__c, oppProd.TS_Child_Opportunity__r.CPO_Name__r.Name);
                        pageRef.getParameters().put(param.Field_ID__c + lkid, oppProd.TS_Child_Opportunity__r.CPO_Name__c);
                    }
                }*/
           // }
        }
        pageRef.getParameters().put('nooverride', '1');
        pageRef.setRedirect(true);
        return pageRef;
    }

}