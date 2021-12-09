({
	doInit : function(component, event, helper) {         
         helper.fetchFields(component, event, helper);
         helper.fetchUrl(component, event, helper);  
	},
    callSort :function(component, event, helper) {
        var selectedRow = event.currentTarget;
        var index = selectedRow.dataset.record;
        var selectedRecord = component.get("v.fieldSetMemberList")[index].fieldPath;
        component.set("v.arrowDirectionField",component.get("v.fieldSetMemberList")[index].label);
        helper.sortBy(component, selectedRecord);
    },       
	 renderPage: function(component, event, helper) {
        helper.renderPage(component);
    }, 
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
    },
    hideSpinner : function(component,event,helper){  
       component.set("v.Spinner", false);
    }    
})