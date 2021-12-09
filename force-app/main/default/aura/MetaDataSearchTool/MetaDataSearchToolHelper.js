({
    onLoad: function(component, event) {
        //call apex class method
        var action = component.get('c.fetchMetaData');
        var inputFieldIds = component.find("fieldIds").get("v.value");
        var arrayOfIds = inputFieldIds.split(',');
        var fieldIds = '' ;
        var i; 
        for (i = 0; i < arrayOfIds.length; i++) {
            fieldIds += '\'' + arrayOfIds[i] + '\'' + ',';
        }
        fieldIds = fieldIds.slice(0, -1);
        action.setParams({fieldIds:fieldIds});
        action.setCallback(this, function(response){
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListOfContact attribute on component.
                component.set('v.listOfMetadata', response.getReturnValue());
                console.log(response.getReturnValue());
                if(response.getReturnValue().length>0){
                component.set('v.hasData', true);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    convertArrayOfObjectsToCSV : function(component,objectRecords){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header  
        keys = ['RefMetadataComponentId','MetadataComponentName','MetadataComponentType','RefMetadataComponentName' ];
        
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
            
            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                
                // add , [comma] after every String value,. [except first]
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }   
                
                csvStringResult += '"'+ objectRecords[i][skey]+'"'; 
                
                counter++;
                
            } // inner for loop close 
            csvStringResult += lineDivider;
        }// outer main for loop close 
        
        // return the CSV formate String 
        return csvStringResult;        
    },
})