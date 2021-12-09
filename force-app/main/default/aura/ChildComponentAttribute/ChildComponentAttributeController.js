({
    onChildAttributeChange : function (component, event, helper) {
        console.log("Old value: " + event.getParam("oldValue"));
        console.log("Current value: " + event.getParam("value"));
    }
})