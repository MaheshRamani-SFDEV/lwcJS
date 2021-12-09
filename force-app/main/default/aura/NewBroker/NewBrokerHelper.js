({
    createRecord: function(component, event, helper) {
        var action = component.get('c.fetchRecord');
        var myPageRef = component.get("v.pageReference");
        var base64Context = myPageRef.state.inContextOfRef;
        if (base64Context.startsWith("1\.")) {
            base64Context = base64Context.substring(2);
        }
        var addressableContext = JSON.parse(window.atob(base64Context));
        var recId = addressableContext.attributes.recordId;
        var record;
        action.setParams({recordId:recId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                record = response.getReturnValue();
                var createRecordEvent = $A.get("e.force:createRecord");
                createRecordEvent.setParams({
                    "entityApiName": "Broker__c",
                    "defaultFieldValues": {
                        'Name' : component.get("v.userInfo.Name"),
                        'Phone__c' : component.get("v.userInfo.Phone"),
                        //'Email__c' : component.get("v.userInfo.SenderEmail"),
                        'Account__c':record.Name
                        /*'Related_Opportunity_Product__c':record.Id,
                        'Deal__c':record.TS_Child_Opportunity__c,
                        
                        'TSO__c':record.TS_Child_Opportunity__r.TSO_Name__c,
                        'CPO__c':record.TS_Child_Opportunity__r.CPO_Name__c     */                   
                    }
                    
                });
                createRecordEvent.fire(); 
            }
        });
        $A.enqueueAction(action);   
    }
})