({
	doInit : function(component, event, helper) {
        component.set("v.parentRecordId",component.get("v.recordId"));
        helper.doInit(component, event, helper);
	}
})