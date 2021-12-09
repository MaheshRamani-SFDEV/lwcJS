({
    onCallChildMethod : function(component, event, helper) {
        var attribute1 = component.get('v.parentAttribute1');
        var attribute2 = component.get('v.parentAttribute2');
        var childComponent = component.find('child');
        childComponent.myMethod(attribute1, attribute2);
    },
  
    //Below function has nothing to do with component - its for reference of using event.pause(), event.resume() and event.stopPropogation()
    //1. Pauses a component event
	//2. Calls a server-side action
	//3. Then, the action callback resumes or stops the event propagation based on the server response

        handleCmpEvent : function(component, event, helper) {
      // Pause event propagation
      event.pause();
    
      // Call an asynchronous server-side action
      var action = component.get("c.someServerFunction");
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          // Resume event propagation if action succeeded
          event.resume();
        }
        else if (state === "ERROR") {
          // Stop event propagation if action failed
          event.stopPropagation();
        }
      });
      $A.enqueueAction(action);
    }
})