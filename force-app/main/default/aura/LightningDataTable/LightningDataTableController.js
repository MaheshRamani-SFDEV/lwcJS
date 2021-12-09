({
    doInit : function(component, event, helper) {		                
        helper.fetchURL(component, event, helper);
        helper.fetchUITheme(component, event, helper);
        helper.fetchAction(component, event);
    },     
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        switch (action.name) {
            case 'new':
                helper.createRecord(component, event);
                break;
            case 'edit':
                helper.editRecord(component, event);
                break;
            case 'delete':
                helper.deleteRecord(component, event);
                break;
            case 'view':
                helper.viewRecord(component, event);
                break;
        }
    },    
    handleColumnSorting: function (component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },
    handleSearch: function(component, event, helper) {
    	helper.searchRecord(component, event, helper);      
    },  
    handleSave: function (component, event, helper) {
        var draftList = event.getParam('draftValues');
        var action = component.get("c.updateRecord");
        action.setParams({
            recordList : draftList
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS" ) {    
                if (response.getReturnValue() === true ) {                   
                	helper.reloadDataTable(component, event, helper);
                }else {                         
                    helper.toastMsg( 'error', 'Something went wrong. Contact your system administrator.' );  
                }  
            }else {  
                helper.toastMsg( 'error', 'Something went wrong. Contact your system administrator.' );  
            }  
        });
        $A.enqueueAction(action);
    },    
    renderPage: function(component, event, helper) {
        helper.renderPage(component);
    }
    
})