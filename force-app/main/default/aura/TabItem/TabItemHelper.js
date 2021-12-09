({
    showTool : function(component) {
        var showTool = component.get("v.showTool");
        component.set("v.showTool",true);
        var modal = component.find("Tool");
        $A.util.removeClass(modal, 'closeDiv');
    },
    closeTool : function(component) {
        var modal = component.find("Tool");
        $A.util.addClass(modal, 'closeDiv');
        component.set("v.selTabId" , 'tab1');     
    }
})