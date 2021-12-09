({
    doInit : function(component, event, helper) {
         //helper.fetchFields(component, event, helper);
         helper.fetchOpportunity(component, event, helper,component.get("v.recordId"));
     },
    handleClick : function(component, event, helper) {
        var radioBtn = event.getSource().get("v.value");       
        var afList = component.get('v.currentList');        
        for(var i=0; i<afList.length; i++){
            afList[i].isVisible = false;
        }
        afList[parseInt(radioBtn)].isVisible = true;
        component.set("v.currentList", afList);
        component.set("v.isheaderVisible", true);       
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