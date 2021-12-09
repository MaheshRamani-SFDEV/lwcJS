({
    getBigObjectList: function (cmp, event, helper) {
		var action = component.get("c.getOptions");//get data from controller
        action.setCallback(this, function(response){
            component.set("v.options", response.getReturnValue());//set data in the page variable
        }, "SUCCESS");//setCallback(this, function(response){}, param for invoking setCallback - default is success and error, can be set aborted)
        $A.enqueueAction(action);
    },
    handleChange: function (cmp, event) {
        // This will contain the string of the "value" attribute of the selected option
        var selectedOptionValue = event.getParam("value");
        cmp.set('v.options', selectedOptionValue);
    }
})