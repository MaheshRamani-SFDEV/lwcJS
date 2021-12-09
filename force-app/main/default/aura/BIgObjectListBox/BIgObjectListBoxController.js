({
    doInit: function (component, event, helper) {
        helper.getBigObjectList(component);
    },
    handleOptionSelected: function (component, event, helper) {
        //Get the string of the "value" attribute on the selected option
        var selectedObjectValue = event.getParam("value");
        component.set('v.objvalue', selectedObjectValue);
        alert("Selected Option: '" + selectedObjectValue + "'");
        var dualListBox = component.find('child');
        helper.getBigObjectDualBoxFieldList(dualListBox, selectedObjectValue);
    },
    handleSectionToggle: function (component, event, helper) {
        var openSections = event.getParam('openSections');

        if (openSections.length === 0) {
            component.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            component.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    }
})