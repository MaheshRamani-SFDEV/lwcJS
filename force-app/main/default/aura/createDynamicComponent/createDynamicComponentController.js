({
	doInit : function(cmp) {
        //$A.createComponent(String type, Object attributes, function callback)
        $A.createComponent("lightning:button",
                           {
                               "aura:id": "findableAuraId",
                               "label": "Press Me",
                               "onclick": cmp.getReference("c.handlePress")
                           },
                           //callback(cmp, status, errorMessage)
                           function(newButton, status, errorMessage){
                               //Add the new button to the body array
                               if (status === "SUCCESS") {
                                   var body = cmp.get("v.body");
                                   body.push(newButton);
                                   cmp.set("v.body", body);
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
        //creating nested component dynamically
		/*$A.createComponents([
                                ["ui:message",{
                                    "title" : "Sample Thrown Error",
                                    "severity" : "error",
                                }], 
                                ["ui:outputText",{
                                    "value" : e.message
                                }]
        					],
                            function(components, status, errorMessage){
                            	if (status === "SUCCESS") {
                            		var message = components[0];
                            		var outputText = components[1];
                                    // set the body of the ui:message to be the ui:outputText
                                    message.set("v.body", outputText);
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
                           );*/        
    },
    handlePress : function(cmp) {
        // Find the button by the aura:id value
        console.log("button: " + cmp.find("findableAuraId"));
        console.log("button pressed");
    },    
})