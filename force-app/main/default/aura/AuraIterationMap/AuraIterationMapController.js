({
 fetch : function(component, event, helper) {
        var custNo = component.get("v.custNo");
  var action = component.get("c.fetchMapData");   
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var custs = [];
                var conts = response.getReturnValue();
                for(var key in conts){
                    custs.push({value:conts[key], key:key});
                }
                component.set("v.customers", custs);
                component.set("v.showBool", true);
            } 
  });           
        $A.enqueueAction(action);
 }
})