({
	getBigObjectList : function(component) {
        var action = component.get("c.getOptions");
        action.setCallback(this, function(response){
            component.set("v.Options", response.getReturnValue());
        }, "SUCCESS");
        $A.enqueueAction(action);
    },
    getBigObjectDualBoxFieldList : function(dualListBox, objvalue) {
       alert("In bigobject dualbox list" + objvalue);
       var action = dualListBox.get("c.getColumns");
       action.setParams({"objvalue": objvalue});
        
        action.setCallback(this, function(response) {
            alert("response status: " + response.getState() )
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                var opts = [];
                alert(allValues);
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                dualListBox.set("v.listFieldOptions", opts);
            }else{
                alert('Callback Failed in handle change...');
            }
        });
        $A.enqueueAction(action);
	}
})