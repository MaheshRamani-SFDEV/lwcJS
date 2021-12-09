({
	  isValid : function(component) {
        console.log("Validating component");
        var employee = component.get("v.employee");
        return !($A.util.isEmpty(employee.Name) || employee.Age__c === 0 || $A.util.isEmpty(employee.Department__c));       
    },  
    save : function(component){
        console.log("Saving component");        
        var action = component.get("c.save");
        //  console.log(JSON.stringify(component.get("v.employee")));
        action.setParams({
            employee: component.get("v.employee")
        });
       $A.util.toggleClass(component.find('spinner'),'slds-hide');
        action.setCallback(this, function(response){
            $A.util.toggleClass(component.find('spinner'),'slds-hide');
            //  console.log(response.getState());
            if(component.isValid() && response.getState()==="SUCCESS"){
                var blankemployee = {sobjectType:'Employee__c',
                                    Name:'',
                                    Age__c:'',
                                    Department__c:''};
                component.set("v.employee", blankemployee);
                console.log("Firing appplication event");
                var updateemployeeEvent = $A.get("e.c:updateEmployees");
                //console.log(response.getReturnValue());
                updateemployeeEvent.setParams(
                    {
                        employee : response.getReturnValue()
                    });               
                updateemployeeEvent.fire();               
                /*console.log("Firing component event");
                var compEvent = component.getEvent("compEvent");
                console.log("employeeId:" + response.getReturnValue().Id);
                compEvent.setParams({
                    employeeId : response.getReturnValue().Id
                });                
                compEvent.fire();  */              
            }
            else if(response.getState()==="ERROR"){
                var errors = response.getError();
                console.log(JSON.stringify(errors));
                if(errors){
                    if(errors[0] && errors[0].message)
                        console.log(errors[0].message);
                }
                else{
                    console.log("Unknown error!")
                }
            }            
        });        
        $A.enqueueAction(action);
    }
})