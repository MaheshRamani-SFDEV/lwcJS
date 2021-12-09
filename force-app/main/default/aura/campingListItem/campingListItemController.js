({
    packItem: function(component, event, helper)
    {
        console.log("clicked");
        component.set("v.item.Packed__c", true);
        event.getSource().set("v.disabled", true); 
    },
})