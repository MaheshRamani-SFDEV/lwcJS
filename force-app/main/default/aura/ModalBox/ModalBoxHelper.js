({
    showModal : function(component) {      
        var modal = component.find("oppModal");
        $A.util.removeClass(modal, 'hideDiv');        
    },
    
    hideModal : function(component) {
        var modal = component.find("oppModal");
        $A.util.addClass(modal, 'hideDiv');
    }
})