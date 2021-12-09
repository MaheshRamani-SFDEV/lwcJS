({
    getAccountTable1View : function(component) {
        var action = component.get("c.getAccountList");//get data from controller
        action.setCallback(this, function(response){
            component.set("v.accounts", response.getReturnValue());//set data in the page variable
        }, "SUCCESS");//setCallback(this, function(response){}, param for invoking setCallback - default is success and error, can be set aborted)
        $A.enqueueAction(action);
    },
    addAccountRecord: function(component, account) {
   		var accounts = component.get("v.accounts");//get account list
        accounts.push(account);  //add account in accountlist as last row
        component.set("v.accounts", accounts); //refresh accountlist
    },  
    removeAccount : function(component, index, acc) {
    	var accounts = component.get("v.accounts"); 
        accounts.splice(index, 1); // remove row based on index number
    	component.set("v.accounts", accounts); 
        var myEvent = $A.get("e.c:addAccount");//fire event for adding row in component2
        myEvent.setParams({"account2" : acc}); //set event attribute for use in comp 2
        myEvent.fire();
	}  
})