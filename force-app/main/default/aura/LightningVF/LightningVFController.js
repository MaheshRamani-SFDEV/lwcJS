({
 
   /* On the component Load this function call the apex class method, 
    * which is return the list of RecordTypes of object 
    * and set it to the lstOfRecordType attribute to display record Type values
    * on ui:inputSelect component. */
    doInit: function(component, event, helper) {  
  	 	console.log(component.get("v.pageReference").state.recordTypeId);
   		var recordTypeId = component.get("v.pageReference").state.recordTypeId;
        component.set("v.recordTypeId", recordTypeId);      
    },
   fetchListOfRecordTypes: function(component, event, helper) {                  
       var action = component.get("c.fetchRecordTypeValues");
       var opts = [];
       action.setCallback(this, function(response) {
			component.set("v.lstOfRecordType", response.getReturnValue());                  
      });
      $A.enqueueAction(action);
   },
 
   /* In this "createRecord" function, first we have call apex class method 
    * and pass the selected RecordType values[label] and this "getRecTypeId"
    * apex method return the selected recordType ID.
    * When RecordType ID comes, we have call  "e.force:createRecord"
    * event and pass object API Name and 
    * set the record type ID in recordTypeId parameter. and fire this event
    * if response state is not equal = "SUCCESS" then display message on various situations.
    */
    createRecord: function(component, event, helper) {
        var recordTypeId = component.get("v.recordTypeId");
        console.log('recordType ID is: '+recordTypeId);
        var createOpportunity = $A.get("e.force:createRecord");
        createOpportunity.setParams({
            "entityApiName" : "Opportunity",
            "recordTypeId" : recordTypeId, 
            "defaultFieldValues" : {
                'Name' : 'Mahesh'
            }
        });
        createOpportunity.fire();
    },
   createRecord1: function(component, event, helper) {
      //component.set("v.isOpen", true); 
      var selectedProduct = component.find("selectProduct").get("v.value");
      var action = component.get("c.getRecTypeId");
      var recordTypeLabel = component.find("selectid").get("v.value");
      action.setParams({
         "recordTypeLabel": recordTypeLabel
      });
      action.setCallback(this, function(response) {         
          var state = response.getState();
          console.log("state--> "+state);
          if (state === "SUCCESS") {
              var recordTypeId  = response.getReturnValue();
              console.log('selected record type id is: '+recordTypeId);
              sforce.one.createRecord("Opportunity",recordTypeId, {Name:"Mahesh"});  //object name, record type id, default field values
          } else if (state == "INCOMPLETE") {
             sforce.one.showToast({
   				 "title": "Oops!",
               "message": "No Internet Connection"
			});             
         } else if (state == "ERROR") {
             sforce.one.showToast({
   				 "title": "Error!",
               "message": "Please contact your administrator"
			});
         }
      });
      $A.enqueueAction(action);
   },
 
   closeModal: function(component, event, helper) {
      // set "isOpen" attribute to false for hide/close model box 
       component.set("v.isOpen", false); 
                window.history.back();       
   },
 
   openModal: function(component, event, helper) {
      // set "isOpen" attribute to true to show model box
      component.set("v.isOpen", true);
   },
    })