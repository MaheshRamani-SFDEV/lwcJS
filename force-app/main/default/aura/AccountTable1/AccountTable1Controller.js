({
    getAccountTable1View : function(component, event, helper) {
        helper.getAccountTable1View(component);//get data from the helper
    },    
    delAccountEvent : function(component, event, helper){
    	var account = event.getParam("account");//get attribute param from event - account record for adding in comp1
        helper.addAccountRecord(component, account);
    },
    deleteRow : function(component, event, helper) {
		var accounts = component.get("v.accounts"); 
        var index = event.getSource().get("v.value"); // get account record pos based on delete button
        var acc = accounts[index];
   	 	helper.removeAccount(component, index, acc); //pass account record pos and record
  	}
})