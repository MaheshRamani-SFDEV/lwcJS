({
	saveContactRecord : function(component, event, helper) {
        var isValid = true;
        var conObj = component.get("v.objContact");
           //set the default accountId is null 
       //conObj.ParentId = null ;
       conObj.AccountId = null ; 
       // check if selectedLookupRecord is not equal to undefined then set the accountId from 
       // selected Lookup Object to Contact Object before passing this to Server side method
        if(component.get("v.selectedLookUpRecord").Id != undefined){
          //conObj.ParentId = component.get(“v.selectedLookUpRecord”).Id;
          conObj.AccountId = component.get("v.selectedLookUpRecord").Id;
        }else{
            alert('Required : Please Select Record Lookup');
			isValid = false;
        }
        if(isValid){
           //call apex class method
            var action = component.get('c.saveContact');
            action.setParams({
                'con': conObj
            })
            action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
             alert('Record Created');
            }
          });
          $A.enqueueAction(action);
      }         
	}
})