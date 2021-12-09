({
    getCaseRecord : function(component, event, helper) {
        var action = component.get("c.getCaseFromId");
        action.setParams({ 
            caseID : component.get("v.caseId") 
        });
        action.setCallback(this, function(response){
            component.set("v.record", response.getReturnValue());
        });
     $A.enqueueAction(action);
    }
})