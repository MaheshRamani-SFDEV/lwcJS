({
    executeMyMethod : function (component, event, helper) {
        var params = event.getParam("arguments");
        component.set("v.param1", params.param1);
        component.set("v.param2", params.param2);
    }
})