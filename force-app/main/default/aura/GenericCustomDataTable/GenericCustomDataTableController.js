({
    init: function (component, event, helper) {
        var action = component.get("c.getdataRecords");
    	action.setParams({
        strObjectName: component.get("v.sObjectName"),
        strFieldSetName: component.get("v.fieldSetName"),
        numberOfRecords: component.get("v.numberOfRecord")
    })
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS')
            {
                component.set("v.mycolumns", response.getReturnValue().lstDataTableColumns);
                component.set("v.mydata", response.getReturnValue().lstDataTableData);
            }  
            else if (state === 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }else{
                console.log('Something went wrong, Please check with your admin');
            }
        });
        $A.enqueueAction(action); 
    },
    //Method gets called by onsort action,
    handleSort : function(component,event,helper){
        //Returns the field which has to be sorted
        var sortBy = event.getParam("fieldName");
        //returns the direction of sorting like asc or desc
        var sortDirection = event.getParam("sortDirection");
        //Set the sortBy and SortDirection attributes
        component.set("v.sortBy",sortBy);
        component.set("v.sortDirection",sortDirection);
        // call sortData helper function
        helper.sortData(component,sortBy,sortDirection);
    },
    handleSave: function (component, event, helper) {
        var action = component.get("c.updateRecord");
        var draftList = event.getParam('draftValues');
        action.setParams({recList: draftList});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
				helper.reloadDataTable();
            }
        });
        $A.enqueueAction(action);
    },
})