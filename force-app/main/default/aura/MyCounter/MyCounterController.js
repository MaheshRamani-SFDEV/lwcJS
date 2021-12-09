({
    getValue : function(component, event, helper) {
    	component.set("v.value", _counter.getValue());
    },
    increment : function(component, event, helper) {
    	component.set("v.value", _counter.increment());
    }
})