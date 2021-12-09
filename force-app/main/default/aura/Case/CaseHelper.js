({
    fetchData: function (cmp) {
        var action = component.get("c.getCases");
        action.setParams({
            "recordLimit": 10
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                var resultData = response.getReturnValue();
                component.set("v.data", resultData);
            }
        });
        $A.enqueueAction(action);
    }
})