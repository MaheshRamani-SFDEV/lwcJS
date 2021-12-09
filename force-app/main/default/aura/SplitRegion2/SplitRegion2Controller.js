({
    doInit : function(component) {
        //Left Region Component Dynamic Rendering
        var leftCmp = component.get("v.leftRegion");         
        if(leftCmp != undefined || leftCmp != null){
            $A.createComponent(
                leftCmp,
                {
                    "aura:id": "findableAuraId1",                    
                    "recordId":component.get("v.recordId")                
                },                
                function(newLeftRegionComponent, status, errorMessage){
                    //Add the new button to the body array
                    if (status === "SUCCESS") {
                        var body = component.get("v.leftRegionComponent");
                        body.push(newLeftRegionComponent);
                        component.set("v.leftRegionComponent", body);
                    }
                    else if (status === "INCOMPLETE") {
                        console.log("No response from server or client is offline.")
                        // Show offline error
                    }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                        // Show error message
                    }
                }
            );
        }
        //Right Region Component Dynamic Rendering
        var rightCmp = component.get("v.rightRegion");
		var publisherContext = component.get("v.context");        
		if(rightCmp == "forceChatter:feed" && publisherContext == "RECORD"){
            component.set("v.isChatterFeed",true);
            component.set("v.isPublisherContextRecord",true);
            component.set("v.isPublisherContextGlobal",false);
        }
        else if(rightCmp == "forceChatter:feed" && publisherContext == "GLOBAL"){
            component.set("v.isChatterFeed",true);
            component.set("v.isPublisherContextRecord",false);
            component.set("v.isPublisherContextGlobal",true);
        }else{
            component.set("v.isChatterFeed",false);
        }  
        if(rightCmp != undefined || rightCmp != Null){
            $A.createComponent(
                rightCmp,
                {
                    "aura:id": "findableAuraId2",
                    "type": component.get("v.type"),
                    "feedDesign":component.get("v.feedDesign")
                },
                function(newRightRegionComponent, status, errorMessage){
                    //Add the new button to the body array
                    if (status === "SUCCESS") {
                        var body = component.get("v.rightRegionComponent");
                        body.push(newRightRegionComponent);
                        component.set("v.rightRegionComponent", body);
                    }
                    else if (status === "INCOMPLETE") {
                        console.log("No response from server or client is offline.")
                        // Show offline error
                    }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                        // Show error message
                    }
                }
            );
        }
    }
})