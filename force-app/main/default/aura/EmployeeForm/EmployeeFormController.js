({
	saveEmployee : function(component, event, helper) {
 		console.log("Inside controller method");
        if(helper.isValid(component)){
            helper.save(component);
        }
 	}
})