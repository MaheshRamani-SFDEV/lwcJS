({
    doInit: function (component, event, helper) {
        helper.getBigObjectList(component);
    },
    handleOptionSelected: function (component, event, helper) {
        //Get the string of the "value" attribute on the selected option
        var selectedObjectValue = event.getParam("value");
        component.set('v.objValue', selectedObjectValue);
        alert("Selected Option: '" + selectedObjectValue + "'");
        var dualListBox = component.find('child');
        helper.getBigObjectDualBoxFieldList(dualListBox, selectedObjectValue);
    }
})