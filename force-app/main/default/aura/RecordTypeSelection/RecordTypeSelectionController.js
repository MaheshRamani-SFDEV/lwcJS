({
    doInit : function(component, event, helper) {  
        helper.RecordTypeSelectorController(component);  
    },
    createRecordFun : function (component, event, helper) {
        var broker = component.get("v.recordId");
        console.log("broker name is: "+broker);
        var rtDet = document.querySelector('input[name="recordTypeRadio"]:checked');
        if(rtDet != null) {
            document.getElementById("newClientSectionId").style.display = "none" ;
            var createRecordEvent = $A.get("e.force:createRecord");
            createRecordEvent.setParams({
                "entityApiName": "Opportunity",
                "recordTypeId":rtDet.id,
                "defaultField": {'BrokerId__c': broker}
            });
            createRecordEvent.fire();
        }  
    }   
})