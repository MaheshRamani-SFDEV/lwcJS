({
    doInit : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
        var action = component.get("c.getBroker");
        action.setParams({"RecId": component.get("v.recordId")
                         });

        // Configure response handler
        action.setCallback(this, function(response) {
            console.log('status is:'+state);
            var result = response.getReturnValue();
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.broker", response.getReturnValue());
                var b = component.get("v.broker.CurrencyIsoCode");
                var defValue = b;
                helper.fetchTypePicklist(component, defValue );
            } else {
                console.log('Problem getting broker, response state: ' + state);
            }
        });
        $A.enqueueAction(action);
        
    },

    handleSaveBroker: function(component, event, helper) {
        if(helper.validateBrokerForm(component)) {
            
            // Prepare the action to create the new callreport
            var saveBrokerAction = component.get("c.saveBrokerWithEvent");
            saveBrokerAction.setParams({
                "broker": component.get("v.broker"),
            });

            // Configure the response handler for the action
            saveBrokerAction.setCallback(this, function(response) {
                
                var state = response.getState();
                console.log("status id is:"+state);
                if(state === "SUCCESS") {

                    // Prepare a toast UI message
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Broker Saved",
                        "message": "The new broker was created."
                    });

                    // Update the UI: close panel, show toast, refresh event page
                    component.set("v.broker", response.getReturnValue());
                    var broker= component.get("v.broker");
                    var recordid = broker.Id;
                    console.log("record id is:"+recordid);
                    //$A.get("e.force:closeQuickAction").fire();
                   // resultsToast.fire();
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": recordid,
                    });
                    navEvt.fire();
                    //$A.get("e.force:refreshView").fire();
                }
                else if (state === "ERROR") {
                    console.log('Problem saving broker, response state: ' + state);
                }
                else {
                    console.log('Unknown problem, response state: ' + state);
                }
            });

            // Send the request to create the new broker
            $A.enqueueAction(saveBrokerAction);
        }
        
    },

	handleCancel: function(component, event, helper) {
	    $A.get("e.force:closeQuickAction").fire();
    }
    
})