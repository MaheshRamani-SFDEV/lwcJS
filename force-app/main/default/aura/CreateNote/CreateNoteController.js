({
    save : function(component, event, helper) {
        var button = event.getSource().getLocalId();
        var currentUserId = $A.get("$SObjectType.CurrentUser.Id");        
        component.set('v.note.ParentId',component.get("v.ParentId"));
        component.set('v.note.OwnerId',currentUserId);
        var OwnerId = $A.get("$SObjectType.CurrentUser.Id");
        var inputRecord = component.get("v.note");
        var action = component.get("c.createNoteRecord");
        action.setParams({
            note : inputRecord
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var haveNoteForView = component.get("v.haveNoteForView");
                component.set("v.isCreateNote",false);
                if(haveNoteForView){
                    component.set("v.isViewNote",true);
                    component.set("v.noRelatedNote",false);
                }else{
                    component.set("v.isViewNote",false);
                    component.set("v.noRelatedNote",true);
                }
                if(button == 'saveButton'){
                    component.set("v.saveClicked",true);
                    var refreshViewNote = component.get("v.fetchNoteRecord");
                    $A.enqueueAction(refreshViewNote);
                    $A.get('e.force:refreshView').fire();
                }
            } else if (state === 'ERROR'){
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
    cancel : function (component, event, helper) {
        var haveNoteForView = component.get("v.haveNoteForView");
        if(haveNoteForView){
            component.set("v.isViewNote",true);
            component.set("v.noRelatedNote",false);
        }else{
            component.set("v.isViewNote",false);
            component.set("v.noRelatedNote",true);
        }
        component.set("v.isCreateNote",false);
        var refreshViewNote = component.get("v.fetchNoteRecord");
        $A.enqueueAction(refreshViewNote);
    }
})