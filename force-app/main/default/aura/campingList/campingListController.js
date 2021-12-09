({
    doInit : function(component, event, helper) {
	// Load all camping item data
	var action = component.get("c.getItems");
	action.setCallback(this, function(response) {
		var state = response.getState();
        if (state === "SUCCESS") {
            component.set("v.items", response.getReturnValue());
        }
		// Display toast message to indicate load status
        var toastEvent = $A.get("e.force:showToast");
        if (state === 'SUCCESS'){
			toastEvent.setParams({
                "title": "Success!",
				"message": " Your campin items have been loaded successfully."
			});
		}
		else {
				toastEvent.setParams({
					"title": "Error!",
					"message": " Something has gone wrong."
				});
		}
		toastEvent.fire();
	});
	$A.enqueueAction(action);
	},
    handleAddItems: function(component, event, helper) {
        var newItem = event.getParam("item");
        helper.createItem(component, newItem);
    },
    handleAddItem : function (component,event,helper){
             var action = component.get("c.saveItem");
             var item = event.getParam("item");
             var items = component.get("v.items");
             items.push(item);
             component.set("v.items",items);
             action.setParams({"item":item});
             action.setCallback(this,function(response){
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS") {
                    console.log('save');
                }
             });
           $A.enqueueAction(action);  
        }
})