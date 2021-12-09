({
	getBigObjectList : function(component) {
        var action = component.get("c.getOptions");
        action.setCallback(this, function(response){
            component.set("v.Options", response.getReturnValue());
        }, "SUCCESS");
        $A.enqueueAction(action);
    }
})