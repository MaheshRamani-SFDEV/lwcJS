({
    handleChange: function (component, event) {
        // get the updated/changed values   
        var selectedOptionsList = event.getParam("value");
       // get the updated/changed source  
        var targetName = event.getSource().get("v.name");
       
        // update the selected itmes  
        if(targetName == 'Columns'){ 
            component.set("v.selectedFieldItems" , selectedOptionsList);
        }       
    },
    refreshRecordsView : function(component, event, helper) {
        //var currentTab = component.get("v.selTabId");
        component.set("v.selTabId" , 'tab4');
    },
     
})