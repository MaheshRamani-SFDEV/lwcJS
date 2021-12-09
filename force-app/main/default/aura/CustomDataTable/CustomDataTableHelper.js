({
   callForData : function(component, event, helper) {       
        var action = component.get("c.getRecords");  
        action.setParams({ 
            objName: component.get("v.sObjectName"),
            fieldLableList:JSON.stringify(component.get("v.lableList")),
            numberOfRecord:component.get("v.numberOfRecord")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS')
            {
                component.set("v.fieldsetData",response.getReturnValue()); 
            }  
            
        });
        $A.enqueueAction(action); 
     },
    saveDataTable : function(component, event, helper) {
        var editedRecords =  component.find("DataTable").get("v.draftValues");
        var totalRecordEdited = editedRecords.length;
        var action = component.get("c.updateRecords");
        action.setParams({
            'editedRecList' : editedRecords
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //if update is successful
                if(response.getReturnValue() === true){
                    helper.showToast({
                        "title": "Record Update",
                        "type": "success",
                        "message": totalRecordEdited+" Records Updated"
                    });
                    helper.reloadDataTable();
                } else{ //if update got failed
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": "Error in update"
                    });
                }
            }
        });
        $A.enqueueAction(action);
    },

    /*
     * Show toast with provided params
     * */
    showToast : function(params){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },

    /*
     * reload data table
     * */
    reloadDataTable : function(){
    var refreshEvent = $A.get("e.force:refreshView");
        if(refreshEvent){
            refreshEvent.fire();
        }
    },
    
})