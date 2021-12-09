({
    /*fetchFields : function(component, event, helper) {
        var action = component.get("c.getFieldSet");
        action.setParams({
            fieldSetName: component.get("v.fieldSetName")
        });        
        action.setCallback(this, function(response) {           
            var state = response.getState();            
            if( state == "SUCCESS"){               
                component.set('v.fieldSetMemberList',response.getReturnValue());
            }
        })
        $A.enqueueAction(action);
    },*/  
    fetchOpportunity : function(component, event, helper,accId) {
        var action = component.get("c.fetchOpportunities");
        /*action.setParams({ 
            "accId" : accId,
            "strFieldSetName": component.get("v.fieldSetName")
        });*/
        action.setParams({ 
            "accId" : accId
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {            
                var data = response.getReturnValue();
                if(data!=null || data !=undefined){                    
                    if(data.length >0){
                        component.set("v.showTable",true);
                        component.set("v.maxPage", Math.floor((data.length+9)/10));
                    }
                    else{
                        component.set("v.showTable",false);  
                    }
                    component.set("v.recordList", data);
                    component.set("v.oppList", data);
                    this.renderPage(component);
                }
            }
        });     
        $A.enqueueAction(action);
    },
    renderPage: function(component) {
        var data = component.get("v.oppList"),
            pageNumber = component.get("v.pageNumber"),
            pageRecords = data.slice((pageNumber-1)*10, pageNumber*10);
        component.set("v.currentList", pageRecords);        
    },
    showModal : function(component) {      
        var modal = component.find("oppModal");
        $A.util.removeClass(modal, 'hideDiv');        
    },
    
    hideModal : function(component) {
        var modal = component.find("oppModal");
        $A.util.addClass(modal, 'hideDiv');
    }
})