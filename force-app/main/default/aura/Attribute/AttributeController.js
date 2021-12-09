({
	updateAttributeArray : function(component, event) {
        var action = component.get("c.getNameArray");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                component.set("v.attributeArray", response.getReturnValue());
            }          
        });
        $A.enqueueAction(action);
	}
})