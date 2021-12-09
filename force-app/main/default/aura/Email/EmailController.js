({
    /*
    This JavaScript controller is called on component initialization and relies
    on the helper functionality to build a list of email addresses from the
    available people. It then makes a caller to the server to run the actions to
    display information.
    Once the server returns the values, it sets the appropriate values to display
    on the client side.
    */
    handlePeopleChange: function(component, event, helper){
        var people = component.get("v.people");
        var peopleEmails = helper.filterEmails(people);
        var action = component.get("c.findOpportunityCloseDateTime");
        action.setParam("emails", peopleEmails);
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.opportunities", response.getReturnValue());
            } else{
                component.set("v.opportunities",[]);
            }
        });
    	$A.enqueueAction(action);
        var action = component.get("c.findAccountAges");
        action.setParam("emails", peopleEmails);
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
            	component.set("v.accounts", response.getReturnValue());
            } else{
           	 	component.set("v.accounts",[]);
            }
        });
        $A.enqueueAction(action);
    }
})