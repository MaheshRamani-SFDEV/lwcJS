({
    getAccountTable2View : function(component) {
        var action = component.get("c.getAccountList2");//get data from controller
        $A.enqueueAction(action);
        action.setCallback(this, function(response){
            component.set("v.accounts2", response.getReturnValue());//set data in the page variable
        });
    },
	addAccountRecord: function(component, account2) {
   		var accounts2 = component.get("v.accounts2");
        accounts2.push(account2);  
        component.set("v.accounts2", accounts2);
    },   
    removeAccount : function(component, index, acc) {
    	var myEvent = $A.get("e.c:delAccount");
        myEvent.setParams({"account": acc});
        myEvent.fire();
        var accounts2 = component.get("v.accounts2");
        accounts2.splice(index, 1);
    	component.set("v.accounts2", accounts2); 
        
	} 
})