({
    fetchURL : function(component, event, helper) {
        var action = component.get("c.getURL");
        action.setCallback(this, function(response){            
            var state = response.getState();
            if(state === 'SUCCESS'){                
                component.set("v.url", response.getReturnValue());
            }else if (state === 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }else{
                console.log('Something went wrong, Please check with your admin');
            }
        });
        $A.enqueueAction(action);	
    },
    fetchNoteRecord : function(component, event, helper) {                
        var button;
        if(component.get("v.saveClicked")){
            button = "saveClicked";
            component.set("v.saveClicked",false);                        
        }else{
            button = event.getSource().getLocalId(); 
        }
        var refresh = component.find('refreshButton');
        //refresh.set('v.disabled',true);
        var columns =  [
            {label: 'Title', fieldName: 'Title', type: 'url', typeAttributes: { label: { fieldName: 'TitleName' },value:{fieldName: 'Title'}, target: '_blank' }},
            {label: 'Body', fieldName: 'Body', type: 'textarea'},
            {label: 'Created Date', fieldName: 'CreatedDate', type: 'date', typeAttributes: {day: 'numeric',month: 'short',year: 'numeric',hour: '2-digit',minute: '2-digit',second: '2-digit',hour12: true}},
            {label: 'Created By', fieldName: 'CreatedById', type: 'url',  typeAttributes: { label: { fieldName: 'CreatedByName' },value:{fieldName: 'CreatedById'}, target: '_blank' }}
        ];        
        component.set('v.mycolumns',columns);              
        var action = component.get('c.getRelatedNotes');
        action.setParams({
            recordId : component.get("v.recordId")
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var url = component.get("v.url");
            var state = response.getState();
            var data = response.getReturnValue();
            data.forEach(function(data){
                if(data.Title != undefined){
                    data.TitleName = data.Title;
                    data.Title ='https://'+url+'/one/one.app?#/sObject/'+data.Id+'/view';
                }else{
                    data.Title = '';
                    data.TitleName='';
                }
                if(data.CreatedById != undefined){
                    data.CreatedByName = data.CreatedBy.Name;
                    data.CreatedById ='https://'+url+'/one/one.app?#/sObject/'+data.CreatedById+'/view';
                }else{
                    data.CreatedById = '';
                    data.CreatedByName ='';
                }
            });                       
            if (state === "SUCCESS") {
                if(button == 'refreshButton'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "SUCCESS",
                        "title": "Success!",
                        "message": "Notes Are Refreshed!"
                    });
                    toastEvent.fire();
                }else if(button == 'saveClicked'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "SUCCESS",
                        "title": "Success!",
                        "message": "Notes Are Refreshed!"
                    });
                    toastEvent.fire();
                }
                component.set('v.notes', data);
                if($A.util.isEmpty(data)|| $A.util.isUndefinedOrNull(data)){ 
                    component.set("v.noRelatedNote",true);
                    component.set("v.isViewNote",false);
                    component.set("v.haveNoteForView",false);
                    component.set("v.isCreateNote",false);
                    $A.util.addClass(component.find("showTable"), "slds-hide");
        			$A.util.removeClass(component.find("showTable"), "slds-show");
                    $A.util.addClass(component.find("showRelatedNote"), "slds-show");
            		$A.util.removeClass(component.find("showRelatedNote"), "slds-hide");
                }else{
                    component.set("v.isViewNote",true);
                    component.set("v.haveNoteForView",true);
                    component.set("v.noRelatedNote",false);
                    component.set("v.isCreateNote",false); 
                    $A.util.addClass(component.find("showTable"), "slds-show");
        			$A.util.removeClass(component.find("showTable"), "slds-hide");
                    $A.util.addClass(component.find("showRelatedNote"), "slds-hide");
            		$A.util.removeClass(component.find("showRelatedNote"), "slds-show");
                }
                $A.util.addClass(component.find("showChild"), "slds-hide");
                $A.util.removeClass(component.find("showChild"), "slds-show");
                
            } else if (state === "ERROR") {
                //var refresh = component.find('refreshButton');
               // refresh.set('v.disabled',false);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }else{
                //var refresh = component.find('refreshButton');
                //refresh.set('v.disabled',false);
                console.log('Something went wrong, Please check with your admin');
            }
        }));
        $A.enqueueAction(action); 
    },
    showNoteForm : function(component, event, helper) {
        var ParentId = component.get("v.recordId");
        if(ParentId != null){
             //var action = component.get('c.isNoteEnabledBySchema');
             var action = component.get('c.isNoteEnabled');
            action.setParams({
                recordId : component.get("v.recordId")
            });
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();
                var hasNotesEnabled = response.getReturnValue();               
                if (state === "SUCCESS") {                    
                    if(hasNotesEnabled){
                        if(component.get("v.isViewNote")){
                            component.set("v.haveNoteForView",true);
                            component.set("v.isViewNote",false);                           
                        }else{
                            component.set("v.noRelatedNote",false);                            
                        }               
                        component.set("v.isCreateNote",true);
                        $A.util.addClass(component.find("showTable"), "slds-hide");
                        $A.util.removeClass(component.find("showTable"), "slds-show");
                        $A.util.addClass(component.find("showRelatedNote"), "slds-hide");
            			$A.util.removeClass(component.find("showRelatedNote"), "slds-show");
                        $A.util.addClass(component.find("showChild"), "slds-show");
                        $A.util.removeClass(component.find("showChild"), "slds-hide");
                        component.set("v.recordId",ParentId);                
                    }
                    else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "Mode": "Sticky",
                            "type": "ERROR",
                            "title": "Error!",
                            "message": "Notes are not enabled for record page!"
                        });
                        toastEvent.fire();
                    }
                }else if (state === 'ERROR'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "Mode": "Sticky",
                        "type": "ERROR",
                        "title": "Error!",
                        "message": "You must be on a record page that allows notes!"
                    });
                    toastEvent.fire(); 
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "Mode": "Sticky",
                        "type": "ERROR",
                        "title": "Error!",
                        "message": "You must be on a record page that allows notes!"
                    });
                    toastEvent.fire(); 
                    console.log('Something went wrong, Please check with your admin');
                }
            }));
            $A.enqueueAction(action);                 
        }else{            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "Mode": "Sticky",
                "type": "ERROR",
                "title": "Error!",
                "message": "You must be on a record page that allows notes!"
            });
            toastEvent.fire(); 
        } 
    }
})