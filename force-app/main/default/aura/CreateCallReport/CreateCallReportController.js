({
    doInit : function(component, event, helper){
        //close the quick action
        //$A.get("e.force:closeQuickAction").fire();
        //call helper for getting params for callreport record creation from server method
        helper.getCallReportParams(component).then($A.getCallback(function(result){
            //fire new on Call Report
            let createRecord = $A.get("e.force:createRecord");
            //pass callreport creation parameter
            createRecord.setParams(result);
            //fire callreport record creation event
            createRecord.fire();
        })).catch(function(error){
            //show error message
            let toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title" : 'Error Message',
                "message" : error,
                "type" : "error"
            });
            toastEvent.fire();
        });
    }
})