({
    OCRExtrator : function(component,event, helper) {
         //alert('Call Made1');
            let action = component.get('c.getImageText1');
            //pass Id param to server side method
            action.setParams({'recIds': component.get('v.recordId')});
            action.setCallback(this, function(response){
                let state = response.getState();
                //check the state of callback function
                if(state === 'SUCCESS'){
                   var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "SUCCESS",
                        "title": "Success!",
                        "message": "Data Extracted Successfully from Image"
                    });
                    toastEvent.fire();
                    //window.open('/'+component.get('v.recordId'), '_blank');
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "Error",
                        "title": "Error!",
                        "message": "Issue while extracting data from Image!"
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
	}
})