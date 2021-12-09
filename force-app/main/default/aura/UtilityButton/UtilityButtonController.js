({
    NavigateWebToCase : function(component,event, helper) {
		var eUrl= $A.get("e.force:navigateToURL");
          eUrl.setParams({
              "url": 'https://www.google.com/' 
          });
          eUrl.fire();
    },//this method navigate to WebToCase visualforce page which crete case.
    createCaseWithURLLocation : function(component,event, helper) {
		var urlpathname = window.location.pathname;
		window.open('/apex/WebToCase?sourceobjId='+urlpathname.replace('/',''));
    }
})