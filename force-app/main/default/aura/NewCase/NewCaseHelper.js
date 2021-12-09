({
    createRecord: function(component, event, helper) {
        var action = component.get('c.fetchRecordTypeName');
        var recordTypeId;
        var recordTypeName;
        var accountId;
        var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function(part) {
            var item = part.split("=");
            if(item[0] === "recordTypeId"){
                recordTypeId = item[1];
            }
            if(item[0] === "additionalParams"){
                var item2 = decodeURIComponent(item[1]).split("=");
                accountId = item2[1].slice(0, -1);;
            }
        });
        action.setParams({recordTypeId:recordTypeId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                recordTypeName = response.getReturnValue();
                if(recordTypeName=="TMCS" || recordTypeName=="Deposit Opening"){
                    var urlEvent = $A.get("e.force:navigateToURL");
                   /* urlEvent.setParams({
                        "url": "/apex/TS_NewCasePage?retURL="+accountId+"&RecordType="+ recordTypeId + "&ent=Case&nooverride=1&def_account_id="+accountId,
                        "isredirect": "true"
                    });
                    urlEvent.fire();*/
                } else {
                    var createRecordEvent = $A.get("e.force:createRecord");
                    createRecordEvent.setParams({
                        "entityApiName": "Case",
                        "recordTypeId": recordTypeId,
                        "defaultFieldValues": {
                            'AccountId' : accountId
                        }
                        
                    });
                    createRecordEvent.fire(); 
                }
            }
        });
        $A.enqueueAction(action);   
    }
})