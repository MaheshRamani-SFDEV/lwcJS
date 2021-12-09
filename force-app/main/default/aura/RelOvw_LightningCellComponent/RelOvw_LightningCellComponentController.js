({
    doInit : function(component, event, helper) {
        // console.log('## in child lightningcell sObjectName:-->'+component.get('v.sObjectName'));
       helper.doInit(component, event, helper);
    },
    
    onMouseOver: function(component, event, helper) {
        // find the current element (column source) by event 
       // get the field actual value which is store in title, 
        var eventSourceVal =event.getSource().get("v.title");
        // set the value of column with title on mouse over  
        event.getSource().set("v.value", eventSourceVal);
        var img = component.find('imgOver');
        $A.util.addClass(img,'displayhover');
    }
})