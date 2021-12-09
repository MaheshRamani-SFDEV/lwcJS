({
	getBigObjectIndexFieldList : function(component) {
        var action = component.get("c.getIndexFieldOptions");
        action.setParam({
            "objvalue":component.get("v.")
        })
        action.setCallback(this, function(response){
            component.set("v.IndexFieldOptions", response.getReturnValue());
        }, "SUCCESS");
        $A.enqueueAction(action);
    }
})