({
   init : function(component, event, helper) {
      var action = component.get("c.getPhoneNumber");
      action.setParams({"contactId": component.get("v.recordId")});
      action.setCallback(this, function(response) {
         var state = response.getState();
         if(component.isValid() && state == "SUCCESS"){
            component.set("v.destinationNumber", response.getReturnValue());
         } else {
            component.set("v.messageError", true);
         }
      });
      $A.enqueueAction(action);
   },
      sendMessage : function(component, event, helper) {
      var smsMessage = component.get("v.textMessage");
      var number = component.get("v.destinationNumber");
      var recordId = component.get("v.recordId")
      var action = component.get("c.sendMessages");
      action.setParams({"mobNumber": number, "message": smsMessage, "contactId": component.get("v.recordId")});
      action.setCallback(this, function(response) {
         var state = response.getState();
         if(component.isValid() && state == "SUCCESS"){
            $A.get("e.force:closeQuickAction").fire();
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
               "title": "Success!",
               "message": "SMS has been sent woo hoo!"
            });
            toastEvent.fire();
         } else {
            component.set("v.messageError", true);
         }
      });
      $A.enqueueAction(action);
   }
})