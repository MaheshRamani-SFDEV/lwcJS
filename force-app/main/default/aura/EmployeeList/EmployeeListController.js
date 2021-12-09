({
     handleUpdateEmployees : function(component, event, helper) {
         console.log("Handling update event");
         var employee = event.getParam("employee");
         console.log(employee);
         var employees = component.get("v.employees");
         employees.push(employee);
         component.set("v.employees", employees);
     },   
    doInit : function(component, event, helper){
        console.log("Initializing employee list component");
        var action = component.get("c.getAllEmployees");       
        action.setCallback(this, function(response){
            // console.log(response.getReturnValue());            
            if(component.isValid() && response.getState()==="SUCCESS"){
                component.set("v.employees", response.getReturnValue());
                console.log('employee list: '+JSON.stringify(response.getReturnValue()));
            }
        });       
        $A.enqueueAction(action);        
        helper.setColumns(component);
    },
    enableFileUpload: function(cmp, event, helper){
        var selectedRows=event.getParam('selectedRows');
        console.log('selected row: '+JSON.stringify(selectedRows));       
        var localEvent = $A.get('e.c:enableFileUpload');
        localEvent.setParams({employeeId:selectedRows[0].Id});
        localEvent.fire();
    }
})