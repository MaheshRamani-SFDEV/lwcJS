({
    getCallReportParams : function(component) {
        let p = new Promise($A.getCallback(function(resolve,reject){
            //Call Server side method for fetching event object and pre-filled in call report pre-record
            let action = component.get('c.createRecord');
            //pass Id param to server side method
            action.setParams({'recId': component.get('v.recordId'), 
                              'destObjName': component.get('v.destObjName')
                             });
            action.setCallback(this, function(response){
                let state = response.getState();
                //check the state of callback function
                if(state === 'SUCCESS'){
                    //return success values
                    resolve(response.getReturnValue());
                }else{
                    //return rejection error
                    reject(response.getError()[0].message);
                }
            });
            $A.enqueueAction(action);
        }));
        return p;
    }
})