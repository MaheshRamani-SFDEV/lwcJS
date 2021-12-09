({
doInit : function(component, event, helper) {
 
 var action = component.get("c.getFieldSetMember");
    action.setParams({
        objName: component.get("v.sObjectName"),
        fsName: component.get("v.fieldSetName")
    })
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS')
            {
                var data = response.getReturnValue();
                component.set("v.lableList",data);  
                helper.callForData(component, event, helper);
            }   
        });
        $A.enqueueAction(action); 
	},
    onSave : function (component, event, helper) {
        helper.saveDataTable(component, event, helper);
    }
})