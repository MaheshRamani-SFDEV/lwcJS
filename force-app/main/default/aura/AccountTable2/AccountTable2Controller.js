({
    getAccountTable2View : function(component, event, helper) {
        helper.getAccountTable2View(component);//get data from the helper
    },
    addAccountEvent : function(component, event, helper){
    	var account2 = event.getParam("account2");
        helper.addAccountRecord(component, account2);
    },
    addRow : function(component, event, helper){
   	 	var accounts2 = component.get("v.accounts2");
        var index = event.getSource().get('v.value');
        helper.removeAccount(component, index, accounts2[index]);
  	}
})