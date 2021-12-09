({
    doInit : function(component, event, helper) { 
        if(component.get("v.isViewNote")){
            $A.util.addClass(component.find("showTable"), "slds-show");
            $A.util.removeClass(component.find("showTable"), "slds-hide");
            $A.util.addClass(component.find("showChild"), "slds-hide");
            $A.util.removeClass(component.find("showChild"), "slds-show");
            $A.util.addClass(component.find("showRelatedNote"), "slds-hide");
            $A.util.removeClass(component.find("showRelatedNote"), "slds-show");
        }else if(component.get("v.isCreateNote")){
            $A.util.addClass(component.find("showChild"), "slds-show");
            $A.util.removeClass(component.find("showChild"), "slds-hide");
            $A.util.addClass(component.find("showTable"), "slds-hide");
            $A.util.removeClass(component.find("showTable"), "slds-show");
            $A.util.addClass(component.find("showRelatedNote"), "slds-hide");
            $A.util.removeClass(component.find("showRelatedNote"), "slds-show");
        }else if(component.get("v.noRelatedNote")){
            $A.util.addClass(component.find("showChild"), "slds-hide");
            $A.util.removeClass(component.find("showChild"), "slds-show");
            $A.util.addClass(component.find("showTable"), "slds-hide");
            $A.util.removeClass(component.find("showTable"), "slds-show");
            $A.util.addClass(component.find("showRelatedNote"), "slds-show");
            $A.util.removeClass(component.find("showRelatedNote"), "slds-hide");
        }
        helper.fetchURL(component, event, helper);  
        helper.fetchNoteRecord(component, event, helper);       
    },
    createNote : function(component, event, helper) {        
        helper.showNoteForm(component, event, helper);        
    }
})