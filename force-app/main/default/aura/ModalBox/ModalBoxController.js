({
    doInit:function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },
    hideModal : function(component, event, helper) {
        helper.hideModal(component);
    },
    
    showModal : function(component, event, helper) {
        helper.showModal(component);
    }
    })