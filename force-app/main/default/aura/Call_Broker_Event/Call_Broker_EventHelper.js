({
    validateBrokerForm: function(component) {
        var validBroker = true;

        var allValid = component.find('brokerField').reduce(function (validFields, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);

        return(validBroker);
	},
    fetchTypePicklist : function(component, defValue){
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            'objectName': component.get("v.ObjectName"),
            'field_apiname': component.get("v.Type"),
            'nullRequired': true, // includes --None--
            'defaultValue': defValue
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                component.set("v.TypePicklist", a.getReturnValue());
            } 
        });
        $A.enqueueAction(action);
    }
})