global with sharing class LeadConversionVFController {
    
    public LeadConversionVFController(ApexPages.StandardController stdController) {

    }  
    @RemoteAction
    global static PageReference fieldValueMappingForURL(String objectApiName, String recordTypeId, Map<String,string>fieldValueMap) {
        Schema.describeSObjectresult r = Opportunity.SObjectType.getDescribe();
        String keyprefix = r.getkeyprefix();
        PageReference pageRef = new PageReference('/'+keyprefix+'/e');
        pageRef.getParameters().put('RecordType', recordTypeId);
        pageRef.getParameters().put('ent', objectApiName);
        if(fieldValueMap != null){
            String lkid = '_lkid';
            for(Request_Form_Parameter__mdt param :  [SELECT Field_ID__c, Field_Name__c FROM Request_Form_Parameter__mdt WHERE
                                                          Object_Name__c = 'Opportunity'])
            {
                if(param.Field_Name__c == 'Name' && fieldValueMap.get('Name') !=null){
                    pageRef.getParameters().put(param.Field_ID__c, fieldValueMap.get('Name'));
                }else if(param.Field_Name__c == 'LeadSource' && fieldValueMap.get('LeadSource') !=null){
                    pageRef.getParameters().put(param.Field_ID__c, fieldValueMap.get('LeadSource'));
                }else if(param.Field_Name__c == 'OwnerId' && fieldValueMap.get('OwnerId') !=null){
                    pageRef.getParameters().put(param.Field_ID__c, fieldValueMap.get('Owner.Name'));
                    pageRef.getParameters().put(param.Field_ID__c + lkid, fieldValueMap.get('OwnerId'));
                }else if(param.Field_Name__c == 'AccountId' && fieldValueMap.get('AccountId') !=null){
                    pageRef.getParameters().put(param.Field_ID__c, fieldValueMap.get('Account.Name'));
                    pageRef.getParameters().put(param.Field_ID__c + lkid, fieldValueMap.get('AccountId'));
                }
            }
        }
        pageRef.getParameters().put('nooverride', '1');
        pageRef.setRedirect(true);
        return pageRef;
    }     
}